defmodule PgmqBridgeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :pgmq_bridge

  @session_options [
    store: :cookie,
    key: "_pgmq_bridge_key",
    signing_salt: "H7BjVDKQ",
    same_site: "Lax"
  ]

  plug Plug.Static,
    at: "/",
    from: :pgmq_bridge,
    gzip: false,
    only: PgmqBridgeWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :pgmq_bridge
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug PgmqBridgeWeb.Router
end
