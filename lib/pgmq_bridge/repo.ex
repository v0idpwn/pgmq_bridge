defmodule PgmqBridge.Repo do
  use Ecto.Repo,
    otp_app: :pgmq_bridge,
    adapter: Ecto.Adapters.Postgres
end
