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
      valid_attrs = %{
        name: "some name",
        config: %{"connection_string" => "postgres://localhost"},
        kind: "pgmq"
      }

      assert {:ok, %Peer{} = peer} = Settings.create_peer(valid_attrs)
      assert peer.name == "some name"
      assert peer.config == %{"connection_string" => "postgres://localhost"}
      assert peer.kind == :pgmq
    end

    test "create_peer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_peer(@invalid_attrs)
    end

    test "update_peer/2 with valid data updates the peer" do
      peer = peer_fixture()
      update_attrs = %{name: "some updated name", config: %{}, kind: "sqs"}

      assert {:ok, %Peer{} = peer} = Settings.update_peer(peer, update_attrs)
      assert peer.name == "some updated name"
      assert peer.config == %{}
      assert peer.kind == :sqs
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

  describe "mappings" do
    alias PgmqBridge.Settings.Mapping

    import PgmqBridge.SettingsFixtures

    @invalid_attrs %{source_queue: nil, sink_queue: nil, local_queue: nil}

    test "list_mappings/0 returns all mappings" do
      mapping = mapping_fixture()
      assert Settings.list_mappings() == [mapping]
    end

    test "get_mapping!/1 returns the mapping with given id" do
      mapping = mapping_fixture()
      assert Settings.get_mapping!(mapping.id) == mapping
    end

    test "create_mapping/1 with valid data creates a mapping" do
      peer = peer_fixture()

      valid_attrs = %{
        source_queue: "some_source_queue",
        sink_queue: "some_sink_queue",
        local_queue: "some_local_queue",
        source_id: peer.id,
        sink_id: peer.id
      }

      assert {:ok, %Mapping{} = mapping} = Settings.create_mapping(valid_attrs)
      assert mapping.source_queue == "some_source_queue"
      assert mapping.sink_queue == "some_sink_queue"
      assert mapping.local_queue == "some_local_queue"
      assert mapping.source_id == peer.id
      assert mapping.sink_id == peer.id
      assert Repo.preload(mapping, :sink).sink == peer

      # Queue is created:
      assert queue_exists?(mapping.local_queue)
    end

    test "create_mapping/1 without local_queue auto-generates a name" do
      peer = peer_fixture()

      valid_attrs = %{
        source_queue: "some_source_queue",
        sink_queue: "some_sink_queue",
        source_id: peer.id,
        sink_id: peer.id
      }

      assert {:ok, %Mapping{local_queue: local_queue}} = Settings.create_mapping(valid_attrs)
      assert is_binary(local_queue)
    end

    test "create_mapping/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_mapping(@invalid_attrs)
    end

    test "delete_mapping/1 deletes the mapping" do
      mapping = mapping_fixture()
      assert {:ok, %Mapping{}} = Settings.delete_mapping(mapping)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_mapping!(mapping.id) end
      refute queue_exists?(mapping.local_queue)
    end

    test "change_mapping/1 returns a mapping changeset" do
      mapping = mapping_fixture()
      assert %Ecto.Changeset{} = Settings.change_mapping(mapping)
    end
  end

  def queue_exists?(name) do
    %Postgrex.Result{rows: [[result]]} =
      Repo.query!("""
      SELECT EXISTS (
        SELECT FROM
          pg_tables
        WHERE
          schemaname = 'pgmq' AND
          tablename = 'q_#{name}'
      )
      """)

    result
  end
end
