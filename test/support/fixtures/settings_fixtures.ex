defmodule PgmqBridge.SettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PgmqBridge.Settings` context.
  """

  @doc """
  Generate a peer.
  """
  def peer_fixture(attrs \\ %{}) do
    {:ok, peer} =
      attrs
      |> Enum.into(%{
        config: %{},
        kind: "some kind",
        name: "some name"
      })
      |> PgmqBridge.Settings.create_peer()

    peer
  end
end
