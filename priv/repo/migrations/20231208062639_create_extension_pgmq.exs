defmodule PgmqBridge.Repo.Migrations.CreateExtensionPgmq do
  use Ecto.Migration

  def change do
    repo().query!("CREATE EXTENSION IF NOT EXISTS pgmq")
  end
end
