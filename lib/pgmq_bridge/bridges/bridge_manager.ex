defmodule PgmqBridge.Bridges.BridgeManager do
  @moduledoc """
  Oversees a single bridge pipeline
  """

  @max_backoff_ms 5000

  defmodule Backoffs do
    defstruct upstream: 250, downstream: 250
  end

  defmodule State do
    defstruct [
      :mapping,
      :started?,
      :downstream_pid,
      :upstream_pid,
      backoffs: %Backoffs{}
    ]
  end

  use GenServer

  alias PgmqBridge.Bridges.DownstreamPipeline
  alias PgmqBridge.Bridges.UpstreamPipeline
  alias PgmqBridge.Settings.Mapping

  def start_link(opts) do
    mapping = %Mapping{} = Keyword.fetch!(opts, :mapping)
    :ok = validate_mapping!(mapping)

    name = Keyword.fetch!(opts, :name)

    GenServer.start_link(__MODULE__, %State{mapping: mapping, started?: false}, name: name)
  end

  @impl GenServer
  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state, {:continue, :start_pipeline}}
  end

  @impl GenServer
  def handle_continue(:start_pipeline, state) do
    {:ok, upstream} = UpstreamPipeline.start_link(state.mapping)
    {:ok, downstream} = DownstreamPipeline.start_link(state.mapping)

    {:noreply, %State{state | downstream_pid: downstream, upstream_pid: upstream, started?: true}}
  end

  @impl GenServer
  def handle_info({:EXIT, from_pid, reason}, state) do
    %{upstream_pid: upstream, downstream_pid: downstream} = state

    crashed =
      case from_pid do
        ^upstream -> :upstream
        ^downstream -> :downstream
      end

    backoffs = compute_backoffs(crashed, state.backoffs, reason)
    Process.send_after(self(), {:restart, crashed}, backoffs)
    %State{state | backoffs: backoffs}
  end

  @impl GenServer
  def handle_info({:restart, restartable}, state) do
    case restartable do
      :upstream ->
        {:ok, upstream} = UpstreamPipeline.start_link(state.mapping)
        {:noreply, %State{state | upstream_pid: upstream}}

      :downstream ->
        {:ok, downstream} = DownstreamPipeline.start_link(state.mapping)
        {:noreply, %State{state | downstream_pid: downstream}}
    end
  end

  defp compute_backoffs(crashed, backoffs, _reason) do
    Map.update!(backoffs, crashed, fn current ->
      min(current * 2, @max_backoff_ms)
    end)
  end

  defp validate_mapping!(mapping) do
    Ecto.assoc_loaded?(mapping.source) || raise ArgumentError, "missing source"
    Ecto.assoc_loaded?(mapping.sink) || raise ArgumentError, "missing sink"
    :ok
  end
end
