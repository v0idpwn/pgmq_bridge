defmodule PgmqBridge.Settings.Mapping do
  use Ecto.Schema
  import Ecto.Changeset

  alias PgmqBridge.Settings.Peer

  schema "mappings" do
    field :source_queue, :string
    field :sink_queue, :string
    field :local_queue, :string, autogenerate: {__MODULE__, :autogen_local_queue, []}
    belongs_to :source, Peer, source: :source_peer
    belongs_to :sink, Peer, source: :sink_peer

    timestamps(type: :utc_datetime)
  end

  # TODO: take kind as a parameter, as different kinds of peers may have different
  # queue name validation rules
  @doc false
  def changeset(mapping, attrs) do
    mapping
    |> cast(attrs, [:source_queue, :sink_queue, :local_queue, :source_id, :sink_id])
    |> validate_required([:source_queue, :sink_queue, :source_id, :sink_id])
    |> validate_queue_name(:source_queue)
    |> validate_queue_name(:sink_queue)
    |> validate_queue_name(:local_queue)
  end

  defp validate_queue_name(changeset, field_name) do
    changeset
    |> validate_format(field_name, ~r/^([a-zA-Z]|_)+$/)
    |> validate_length(field_name, min: 3, max: 40)
  end

  def autogen_local_queue() do
    Ecto.UUID.generate()
    |> Base.encode64(padding: false)
    |> String.slice(0..40)
  end
end
