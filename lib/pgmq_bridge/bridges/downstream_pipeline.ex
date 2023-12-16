defmodule PgmqBridge.Bridge.DownstreamPipeline do
  # use Broadway

  # def start_link(_opts) do
  # Broadway.start_link(opts)
  # end

  # @impl Broadway
  # def handle_message(message) do
  # message
  # end

  # TODO: queues could be cached but we would need to review consistency guarantees
  # @impl Broadway
  # def handle_batch(messages, opts) do
  # PgmqBridge.Repo.transaction(fn ->
  # opts
  # |> PgmqBridge.Settings.get_queues()
  # |> Enum.each(fn queue ->
  #  Enum.each(messages, fn message ->
  #    PgmqBridge.Queues.send_message(queue, message)
  #  end)
  # end)
  # end)
  # end
end
