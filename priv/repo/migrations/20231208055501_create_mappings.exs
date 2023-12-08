defmodule PgmqBridge.Repo.Migrations.CreateMappings do
  use Ecto.Migration

  def change do
    create table(:mappings) do
      add :source_queue, :string
      add :sink_queue, :string
      add :local_queue, :string
      add :source_peer, references(:peers, on_delete: :nothing)
      add :sink_peer, references(:peers, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:mappings, [:source_peer])
    create index(:mappings, [:sink_peer])
  end
end
