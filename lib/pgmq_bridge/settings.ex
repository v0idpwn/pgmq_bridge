defmodule PgmqBridge.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias PgmqBridge.Repo

  alias PgmqBridge.Settings.Peer

  @doc """
  Returns the list of peers.

  ## Examples

      iex> list_peers()
      [%Peer{}, ...]

  """
  def list_peers do
    Repo.all(Peer)
  end

  @doc """
  Gets a single peer.

  Raises `Ecto.NoResultsError` if the Peer does not exist.

  ## Examples

      iex> get_peer!(123)
      %Peer{}

      iex> get_peer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_peer!(id), do: Repo.get!(Peer, id)

  @doc """
  Creates a peer.

  ## Examples

      iex> create_peer(%{field: value})
      {:ok, %Peer{}}

      iex> create_peer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_peer(attrs \\ %{}) do
    %Peer{}
    |> Peer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a peer.

  ## Examples

      iex> update_peer(peer, %{field: new_value})
      {:ok, %Peer{}}

      iex> update_peer(peer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_peer(%Peer{} = peer, attrs) do
    peer
    |> Peer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a peer.

  ## Examples

      iex> delete_peer(peer)
      {:ok, %Peer{}}

      iex> delete_peer(peer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_peer(%Peer{} = peer) do
    Repo.delete(peer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking peer changes.

  ## Examples

      iex> change_peer(peer)
      %Ecto.Changeset{data: %Peer{}}

  """
  def change_peer(%Peer{} = peer, attrs \\ %{}) do
    Peer.changeset(peer, attrs)
  end
end
