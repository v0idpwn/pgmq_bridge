defmodule PgmqBridge.Settings.Mapping do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mappings" do
    field :source_queue, :string
    field :sink_queue, :string
    field :local_queue, :string
    field :source_peer, :id
    field :sink_peer, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(mapping, attrs) do
    mapping
    |> cast(attrs, [:source_queue, :sink_queue, :local_queue])
    |> validate_required([:source_queue, :sink_queue, :local_queue])
  end
end
