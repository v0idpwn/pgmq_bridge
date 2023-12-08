defmodule PgmqBridgeWeb.MappingController do
  use PgmqBridgeWeb, :controller

  alias PgmqBridge.Settings
  alias PgmqBridge.Settings.Mapping

  action_fallback PgmqBridgeWeb.FallbackController

  def index(conn, _params) do
    mappings = Settings.list_mappings()
    render(conn, :index, mappings: mappings)
  end

  def create(conn, %{"mapping" => mapping_params}) do
    with {:ok, %Mapping{} = mapping} <- Settings.create_mapping(mapping_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/mappings/#{mapping}")
      |> render(:show, mapping: mapping)
    end
  end

  def show(conn, %{"id" => id}) do
    mapping = Settings.get_mapping!(id)
    render(conn, :show, mapping: mapping)
  end

  def delete(conn, %{"id" => id}) do
    mapping = Settings.get_mapping!(id)

    with {:ok, %Mapping{}} <- Settings.delete_mapping(mapping) do
      send_resp(conn, :no_content, "")
    end
  end
end
