defmodule PgmqBridgeWeb.PeerJSON do
  alias PgmqBridge.Settings.Peer

  @doc """
  Renders a list of peers.
  """
  def index(%{peers: peers}) do
    %{data: for(peer <- peers, do: data(peer))}
  end

  @doc """
  Renders a single peer.
  """
  def show(%{peer: peer}) do
    %{data: data(peer)}
  end

  defp data(%Peer{} = peer) do
    %{
      id: peer.id,
      name: peer.name,
      kind: peer.kind,
      config: peer.config
    }
  end
end
