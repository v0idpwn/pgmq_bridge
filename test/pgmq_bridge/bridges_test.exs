defmodule PgmqBridge.BridgesTest do
  use PgmqBridge.DataCase
  import PgmqBridge.SettingsFixtures

  alias PgmqBridge.Bridges

  setup do
    peer = peer_fixture()
    mapping = mapping_fixture(sink_id: peer.id, source_id: peer.id)

    {:ok, %{peer: peer, mapping: mapping}}
  end

  describe "start_bridge/2" do
    test "errors if mapping has no sink/source loaded", %{mapping: m0} do
      m1 = Map.put(m0, :source, %Ecto.Association.NotLoaded{})

      assert_raise(ArgumentError, "missing source", fn ->
        Bridges.start_bridge(m1, [])
      end)

      m2 = Map.put(m0, :sink, %Ecto.Association.NotLoaded{})

      assert_raise(ArgumentError, "missing sink", fn ->
        Bridges.start_bridge(m2, [])
      end)
    end

    test "properly start a bridge manager worker under the supervisor", %{mapping: m} do
      dyn_sup = Process.whereis(PgmqBridge.BridgeSupervisor)
      {:ok, pid} = Bridges.start_bridge(m, [])
      {:links, links} = Process.info(pid, :links)
      assert dyn_sup in links
    end

    test "if bridge exists, return it instead of creating a new one", %{mapping: m} do
      {:ok, pid} = Bridges.start_bridge(m, [])
      {:ok, ^pid} = Bridges.start_bridge(m, [])
    end
  end
end
