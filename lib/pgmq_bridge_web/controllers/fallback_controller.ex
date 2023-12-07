defmodule PgmqBridgeWeb.FallbackController do
  use PgmqBridgeWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: PgmqBridgeWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: PgmqBridgeWeb.ErrorHTML, json: PgmqBridgeWeb.ErrorJSON)
    |> render(:"404")
  end
end
