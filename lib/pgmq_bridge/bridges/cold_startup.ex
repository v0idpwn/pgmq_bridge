defmodule PgmqBridge.Bridges.ColdStartup do
  @moduledoc """
  This process starts bridges on application startup
  """

  use GenServer, restart: :transient

  alias PgmqBridge.Bridges

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    mappings = PgmqBridge.Settings.list_mappings()
    {:ok, mappings, {:continue, :start_bridges}}
  end

  @impl GenServer
  def handle_continue(:start_bridges, mappings) do
    mappings
    |> Task.async_stream(
      fn mapping ->
        Bridges.start_bridge(mapping, [])
      end,
      ordered: false
    )
    |> Stream.run()

    {:stop, :normal, nil}
  end
end
