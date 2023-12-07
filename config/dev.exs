import Config

config :pgmq_bridge, PgmqBridge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "pgmq_bridge_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :pgmq_bridge, PgmqBridgeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "GXSR7tp7ztEiEfFxfOvNqvN9LcbG3RuJ560gEB9xDOpSi6K5nhs02NTEq0tYZ8hB",
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
