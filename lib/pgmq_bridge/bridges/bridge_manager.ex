defmodule PgmqBridge.Bridges.BridgeManager do
  @moduledoc """
  Oversees a single bridge pipeline
  """

  defmodule State do
    defstruct [:mapping, :started?]
  end

  use GenServer

  alias PgmqBridge.Settings.Mapping

  def start_link(opts) do
    mapping = %Mapping{} = Keyword.fetch!(opts, :mapping)
    :ok = validate_mapping!(mapping)

    name = Keyword.fetch!(opts, :name)

    GenServer.start_link(__MODULE__, %State{mapping: mapping, started?: false}, name: name)
  end

  @impl GenServer
  def init(state) do
    {:ok, state, {:continue, :start_pipeline}}
  end

  @impl GenServer
  def handle_continue(:start_pipeline, state) do
    {:noreply, state}
  end

  defp validate_mapping!(mapping) do
    Ecto.assoc_loaded?(mapping.source) || raise ArgumentError, "missing source"
    Ecto.assoc_loaded?(mapping.sink) || raise ArgumentError, "missing sink"
    :ok
  end
end
