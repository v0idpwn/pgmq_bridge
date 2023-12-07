defmodule PgmqBridge.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PgmqBridgeWeb.Telemetry,
      PgmqBridge.Repo,
      {DNSCluster, query: Application.get_env(:pgmq_bridge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PgmqBridge.PubSub},
      PgmqBridgeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: PgmqBridge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PgmqBridgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
