import Config

config :pgmq_bridge, PgmqBridge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "pgmq_bridge_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :pgmq_bridge, PgmqBridgeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "wOqWWk27CBSPwy7TKFlDzLpwWoensCPBCzV9NI199g8+WAHn436J8fasATpdrLX4",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
