defmodule PgmqBridge.SettingsFixtures do
  def peer_fixture(attrs \\ %{}) do
    {:ok, peer} =
      attrs
      |> Enum.into(%{
        config: %{},
        kind: "pgmq",
        name: "some name"
      })
      |> PgmqBridge.Settings.create_peer()

    peer
  end
end
