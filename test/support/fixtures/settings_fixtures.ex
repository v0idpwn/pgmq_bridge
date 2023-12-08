defmodule PgmqBridge.SettingsFixtures do
  def peer_fixture(attrs \\ %{}) do
    {:ok, peer} =
      attrs
      |> Enum.into(%{
        config: %{
          "connection_string" => "postgres://postgres:postgres@localhost:5432/postgres"
        },
        kind: "pgmq",
        name: "some name"
      })
      |> PgmqBridge.Settings.create_peer()

    peer
  end
end
