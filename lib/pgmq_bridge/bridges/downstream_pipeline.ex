defmodule PgmqBridge.Bridges.DownstreamPipeline do
  @moduledoc """
  Pipeline from bridge -> remote

  TODO: rename module
  """

  use Broadway

  alias PgmqBridge.Settings.Mapping
  alias PgmqBridge.Settings.Peer
  alias PgmqBridge.Bridges.RemoteDbRepo

  def start_link(%Mapping{sink: %Peer{kind: :pgmq}} = mapping) do
    producer_opts = [
      repo: PgmqBridge.Repo,
      queue: mapping.local_queue,
      visibility_timeout: 10,
      max_poll_seconds: 5,
      poll_interval_ms: 100,
      attempt_interval_ms: 500
    ]

    {:ok, _pid} = start_dyn_repo(mapping)

    Broadway.start_link(__MODULE__,
      name: name(mapping, Broadway),
      producer: [
        module: {OffBroadwayPgmq, producer_opts},
        concurrency: 1
      ],
      processors: [
        default: [concurrency: 1]
      ],
      batchers: [
        default: [batch_size: 10, concurrency: 1]
      ],
      context: %{
        remote_queue: mapping.sink_queue,
        remote_repo: RemoteDbRepo,
        remote_dyn_repo: name(mapping, Repo)
      }
    )
  end

  def handle_message(_, %Broadway.Message{} = message, _) do
    message
  end

  def handle_batch(_, messages, _, context) do
    context.remote_repo.put_dynamic_repo(context.remote_dyn_repo)

    {:ok, _} =
      Pgmq.send_messages(
        context.remote_repo,
        context.remote_queue,
        Enum.map(messages, & &1.data.body)
      )

    messages
  end

  defp start_dyn_repo(mapping) do
    connection_string = mapping.sink.config["connection_string"]

    RemoteDbRepo.start_link(
      url: connection_string,
      pool_size: 2,
      name: name(mapping, Repo)
    )
  end

  defp name(mapping, process) do
    Module.concat([
      __MODULE__,
      process,
      inspect(mapping.id)
    ])
  end
end
