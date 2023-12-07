defmodule PgmqBridgeWeb.PeerControllerTest do
  use PgmqBridgeWeb.ConnCase

  import PgmqBridge.SettingsFixtures

  alias PgmqBridge.Settings.Peer

  @create_attrs %{
    name: "some name",
    config: %{},
    kind: "pgmq"
  }

  @update_attrs %{
    name: "some updated name",
    config: %{},
    kind: "sqs"
  }

  @invalid_attrs %{name: nil, config: nil, kind: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all peers", %{conn: conn} do
      conn = get(conn, ~p"/api/peers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create peer" do
    test "renders peer when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/peers", peer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/peers/#{id}")

      assert %{
               "id" => ^id,
               "config" => %{},
               "kind" => "pgmq",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/peers", peer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update peer" do
    setup [:create_peer]

    test "renders peer when data is valid", %{conn: conn, peer: %Peer{id: id} = peer} do
      conn = put(conn, ~p"/api/peers/#{peer}", peer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/peers/#{id}")

      assert %{
               "id" => ^id,
               "config" => %{},
               "kind" => "sqs",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, peer: peer} do
      conn = put(conn, ~p"/api/peers/#{peer}", peer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete peer" do
    setup [:create_peer]

    test "deletes chosen peer", %{conn: conn, peer: peer} do
      conn = delete(conn, ~p"/api/peers/#{peer}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/peers/#{peer}")
      end
    end
  end

  defp create_peer(_) do
    peer = peer_fixture()
    %{peer: peer}
  end
end
