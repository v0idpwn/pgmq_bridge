defmodule PgmqBridgeWeb.MappingControllerTest do
  use PgmqBridgeWeb.ConnCase

  import PgmqBridge.SettingsFixtures

  @invalid_attrs %{source_queue: nil, sink_queue: nil, local_queue: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json"), peer: peer_fixture()}
  end

  describe "index" do
    test "lists all mappings", %{conn: conn} do
      conn = get(conn, ~p"/api/mappings")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create mapping" do
    test "renders mapping when data is valid", %{conn: conn, peer: peer} do
      conn = post(conn, ~p"/api/mappings", mapping: create_attrs(peer))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/mappings/#{id}")

      assert %{
               "id" => ^id,
               "local_queue" => "some_local_queue",
               "sink_queue" => "some_sink_queue",
               "source_queue" => "some_source_queue"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/mappings", mapping: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete mapping" do
    setup [:create_mapping]

    test "deletes chosen mapping", %{conn: conn, mapping: mapping} do
      conn = delete(conn, ~p"/api/mappings/#{mapping}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/mappings/#{mapping}")
      end
    end
  end

  defp create_mapping(_) do
    mapping = mapping_fixture()
    %{mapping: mapping}
  end

  defp create_attrs(peer) do
    %{
      source_queue: "some_source_queue",
      sink_queue: "some_sink_queue",
      local_queue: "some_local_queue",
      source_id: peer.id,
      sink_id: peer.id
    }
  end
end
