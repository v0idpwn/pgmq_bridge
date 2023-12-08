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

  @doc """
  Generate a mapping.
  """
  def mapping_fixture(attrs \\ %{}) do
    {:ok, mapping} =
      attrs
      |> Enum.into(%{
        local_queue: "some_local_queue",
        sink_queue: "some_sink_queue",
        source_queue: "some_source_queue"
      })
      |> PgmqBridge.Settings.create_mapping()

    mapping
  end
end
