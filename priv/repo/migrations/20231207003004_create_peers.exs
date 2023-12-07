defmodule PgmqBridge.Repo.Migrations.CreatePeers do
  use Ecto.Migration

  def change do
    create table(:peers) do
      add :name, :string
      add :kind, :string
      add :config, :map

      timestamps(type: :utc_datetime)
    end
  end
end
