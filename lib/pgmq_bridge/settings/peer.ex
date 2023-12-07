defmodule PgmqBridge.Settings.Peer do
  use Ecto.Schema
  import Ecto.Changeset

  @kinds [:pgmq, :sqs]

  schema "peers" do
    field :name, :string
    field :config, :map
    field :kind, Ecto.Enum, values: @kinds

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(peer, attrs) do
    peer
    |> cast(attrs, [:name, :kind, :config])
    |> validate_required([:name, :kind])
  end
end
