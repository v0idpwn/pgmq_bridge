defmodule PgmqBridgeWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint PgmqBridgeWeb.Endpoint

      use PgmqBridgeWeb, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import PgmqBridgeWeb.ConnCase
    end
  end

  setup tags do
    PgmqBridge.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
