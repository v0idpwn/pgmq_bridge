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
    |> validate_config()
  end

  # TODO: make a pluggable interface, so that plugins can be written
  defp validate_config(changeset) do
    if changeset.valid? do
      kind = get_field(changeset, :kind)
      config = get_field(changeset, :config)
      errors = validate_config(kind, config)

      Enum.reduce(errors, changeset, fn {original_key, {error, _error_meta}}, changeset ->
        add_error(changeset, :config, error, original_key: original_key)
      end)
    else
      changeset
    end
  end

  defp validate_config(:pgmq, config) do
    config_changeset =
      {%{}, %{connection_string: :string}}
      |> cast(config, [:connection_string])
      |> validate_required([:connection_string])
      |> validate_change(:connection_string, fn :connection_string, value ->
        case URI.parse(value) do
          %URI{scheme: "postgres", host: some_host} when not is_nil(some_host) ->
            []

          _error ->
            [{:connection_string, "Invalid postgres connection string"}]
        end
      end)

    config_changeset.errors
  end

  defp validate_config(:sqs, _config), do: []
end
