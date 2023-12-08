defmodule PgmqBridgeWeb.Router do
  use PgmqBridgeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PgmqBridgeWeb do
    pipe_through :api
    resources "/peers", PeerController, except: [:new, :edit]
    resources "/mappings", MappingController, except: [:new, :edit, :update]
  end
end
