defmodule PgmqBridge.Settings do
  import Ecto.Query, warn: false
  alias PgmqBridge.Repo
  alias PgmqBridge.Queues

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

  alias PgmqBridge.Settings.Mapping

  @doc """
  Returns the list of mappings.

  ## Examples

      iex> list_mappings()
      [%Mapping{}, ...]

  """
  def list_mappings do
    Repo.all(Mapping)
  end

  @doc """
  Gets a single mapping.

  Raises `Ecto.NoResultsError` if the Mapping does not exist.

  ## Examples

      iex> get_mapping!(123)
      %Mapping{}

      iex> get_mapping!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mapping!(id), do: Repo.get!(Mapping, id)

  @doc """
  Creates a mapping.

  ## Examples

      iex> create_mapping(%{field: value})
      {:ok, %Mapping{}}

      iex> create_mapping(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  @doc """
  Updates a mapping.

  ## Examples

      iex> update_mapping(mapping, %{field: new_value})
      {:ok, %Mapping{}}

      iex> update_mapping(mapping, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mapping(%Mapping{} = mapping, attrs) do
    mapping
    |> Mapping.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mapping.

  ## Examples

      iex> delete_mapping(mapping)
      {:ok, %Mapping{}}

      iex> delete_mapping(mapping)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mapping(%Mapping{} = mapping) do
    Repo.delete(mapping)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mapping changes.

  ## Examples

      iex> change_mapping(mapping)
      %Ecto.Changeset{data: %Mapping{}}

  """
  def change_mapping(%Mapping{} = mapping, attrs \\ %{}) do
    Mapping.changeset(mapping, attrs)
  end
end
