defmodule PgmqBridge.Bridges do
  alias PgmqBridge.Bridges.BridgeManager

  # TODO: avoid duplicate children
  def start_bridge(%PgmqBridge.Settings.Mapping{} = mapping, _opts) do
    name = gen_name(mapping)
    child_spec = BridgeManager.child_spec(mapping: mapping, name: name)

    case DynamicSupervisor.start_child(PgmqBridge.BridgeSupervisor, child_spec) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, {exception, stacktrace}} when is_exception(exception) ->
        reraise(exception, stacktrace)

      {:error, other_error} ->
        {:error, other_error}
    end
  end

  defp gen_name(%PgmqBridge.Settings.Mapping{id: id}) do
    {:via, Registry, {PgmqBridge.BridgeRegistry, "mapping#{id}"}}
  end
end
