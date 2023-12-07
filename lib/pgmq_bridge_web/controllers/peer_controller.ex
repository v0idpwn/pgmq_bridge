defmodule PgmqBridgeWeb.PeerController do
  use PgmqBridgeWeb, :controller

  alias PgmqBridge.Settings
  alias PgmqBridge.Settings.Peer

  action_fallback PgmqBridgeWeb.FallbackController

  def index(conn, _params) do
    peers = Settings.list_peers()
    render(conn, :index, peers: peers)
  end

  def create(conn, %{"peer" => peer_params}) do
    with {:ok, %Peer{} = peer} <- Settings.create_peer(peer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/peers/#{peer}")
      |> render(:show, peer: peer)
    end
  end

  def show(conn, %{"id" => id}) do
    peer = Settings.get_peer!(id)
    render(conn, :show, peer: peer)
  end

  def update(conn, %{"id" => id, "peer" => peer_params}) do
    peer = Settings.get_peer!(id)

    with {:ok, %Peer{} = peer} <- Settings.update_peer(peer, peer_params) do
      render(conn, :show, peer: peer)
    end
  end

  def delete(conn, %{"id" => id}) do
    peer = Settings.get_peer!(id)

    with {:ok, %Peer{}} <- Settings.delete_peer(peer) do
      send_resp(conn, :no_content, "")
    end
  end
end
