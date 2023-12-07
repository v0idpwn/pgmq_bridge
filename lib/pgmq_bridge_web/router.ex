defmodule PgmqBridgeWeb.Router do
  use PgmqBridgeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PgmqBridgeWeb do
    pipe_through :api
  end
end
