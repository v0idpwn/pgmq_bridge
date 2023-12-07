defmodule PgmqBridge.Settings do
  import Ecto.Query, warn: false
  alias PgmqBridge.Repo

  alias PgmqBridge.Settings.Peer

  def list_peers do
    Repo.all(Peer)
  end

  def get_peer!(id), do: Repo.get!(Peer, id)

  def create_peer(attrs \\ %{}) do
    %Peer{}
    |> Peer.changeset(attrs)
    |> Repo.insert()
  end

  def update_peer(%Peer{} = peer, attrs) do
    peer
    |> Peer.changeset(attrs)
    |> Repo.update()
  end

  def delete_peer(%Peer{} = peer) do
    Repo.delete(peer)
  end

  def change_peer(%Peer{} = peer, attrs \\ %{}) do
    Peer.changeset(peer, attrs)
  end
end
