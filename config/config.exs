import Config

config :pgmq_bridge,
  ecto_repos: [PgmqBridge.Repo],
  generators: [timestamp_type: :utc_datetime]

config :pgmq_bridge, PgmqBridgeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: PgmqBridgeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PgmqBridge.PubSub,
  live_view: [signing_salt: "+59GJpnX"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
