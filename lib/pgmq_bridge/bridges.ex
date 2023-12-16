defmodule PgmqBridge.Bridges do
  alias PgmqBridge.Bridges.BridgeManager

  # TODO: avoid duplicate children
  def start_bridge(%PgmqBridge.Settings.Mapping{} = mapping, _opts) do
    child_spec = BridgeManager.child_spec(mapping: mapping)
    DynamicSupervisor.start_child(PgmqBridge.BridgeSupervisor, child_spec)
  end
end
