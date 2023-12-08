defmodule PgmqBridge.Settings do
  import Ecto.Query, warn: false

  alias PgmqBridge.Repo
  alias PgmqBridge.Queues

  alias PgmqBridge.Settings.Mapping
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

  def list_mappings do
    Repo.all(Mapping)
  end

  def get_mapping!(id), do: Repo.get!(Mapping, id)

  def create_mapping(attrs \\ %{}) do
    Repo.transaction(fn ->
      %Mapping{}
      |> Mapping.changeset(attrs)
      |> Repo.insert()
      |> case do
        {:ok, mapping} ->
          :ok = Queues.create_queue(mapping.local_queue)
          mapping

        {:error, error} ->
          Repo.rollback(error)
      end
    end)
  end

  def delete_mapping(%Mapping{} = mapping) do
    Repo.delete(mapping)
  end

  def change_mapping(%Mapping{} = mapping, attrs \\ %{}) do
    Mapping.changeset(mapping, attrs)
  end
end
