defmodule PgmqBridge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PgmqBridgeWeb.Telemetry,
      PgmqBridge.Repo,
      {DNSCluster, query: Application.get_env(:pgmq_bridge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PgmqBridge.PubSub},
      # Start a worker by calling: PgmqBridge.Worker.start_link(arg)
      # {PgmqBridge.Worker, arg},
      # Start to serve requests, typically the last entry
      PgmqBridgeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PgmqBridge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PgmqBridgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
