defmodule PgmqBridgeWeb.MappingControllerTest do
  use PgmqBridgeWeb.ConnCase

  import PgmqBridge.SettingsFixtures

  alias PgmqBridge.Settings.Mapping

  @create_attrs %{
    source_queue: "some source_queue",
    sink_queue: "some sink_queue",
    local_queue: "some local_queue"
  }
  @update_attrs %{
    source_queue: "some updated source_queue",
    sink_queue: "some updated sink_queue",
    local_queue: "some updated local_queue"
  }
  @invalid_attrs %{source_queue: nil, sink_queue: nil, local_queue: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all mappings", %{conn: conn} do
      conn = get(conn, ~p"/api/mappings")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create mapping" do
    test "renders mapping when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/mappings", mapping: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/mappings/#{id}")

      assert %{
               "id" => ^id,
               "local_queue" => "some local_queue",
               "sink_queue" => "some sink_queue",
               "source_queue" => "some source_queue"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/mappings", mapping: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update mapping" do
    setup [:create_mapping]

    test "renders mapping when data is valid", %{conn: conn, mapping: %Mapping{id: id} = mapping} do
      conn = put(conn, ~p"/api/mappings/#{mapping}", mapping: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/mappings/#{id}")

      assert %{
               "id" => ^id,
               "local_queue" => "some updated local_queue",
               "sink_queue" => "some updated sink_queue",
               "source_queue" => "some updated source_queue"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, mapping: mapping} do
      conn = put(conn, ~p"/api/mappings/#{mapping}", mapping: @invalid_attrs)
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
end