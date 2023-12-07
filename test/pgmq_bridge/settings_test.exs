defmodule PgmqBridge.SettingsTest do
  use PgmqBridge.DataCase

  alias PgmqBridge.Settings

  describe "peers" do
    alias PgmqBridge.Settings.Peer

    import PgmqBridge.SettingsFixtures

    @invalid_attrs %{name: nil, config: nil, kind: nil}

    test "list_peers/0 returns all peers" do
      peer = peer_fixture()
      assert Settings.list_peers() == [peer]
    end

    test "get_peer!/1 returns the peer with given id" do
      peer = peer_fixture()
      assert Settings.get_peer!(peer.id) == peer
    end

    test "create_peer/1 with valid data creates a peer" do
      valid_attrs = %{name: "some name", config: %{}, kind: "some kind"}

      assert {:ok, %Peer{} = peer} = Settings.create_peer(valid_attrs)
      assert peer.name == "some name"
      assert peer.config == %{}
      assert peer.kind == "some kind"
    end

    test "create_peer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_peer(@invalid_attrs)
    end

    test "update_peer/2 with valid data updates the peer" do
      peer = peer_fixture()
      update_attrs = %{name: "some updated name", config: %{}, kind: "some updated kind"}

      assert {:ok, %Peer{} = peer} = Settings.update_peer(peer, update_attrs)
      assert peer.name == "some updated name"
      assert peer.config == %{}
      assert peer.kind == "some updated kind"
    end

    test "update_peer/2 with invalid data returns error changeset" do
      peer = peer_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_peer(peer, @invalid_attrs)
      assert peer == Settings.get_peer!(peer.id)
    end

    test "delete_peer/1 deletes the peer" do
      peer = peer_fixture()
      assert {:ok, %Peer{}} = Settings.delete_peer(peer)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_peer!(peer.id) end
    end

    test "change_peer/1 returns a peer changeset" do
      peer = peer_fixture()
      assert %Ecto.Changeset{} = Settings.change_peer(peer)
    end
  end
end
