defmodule PgmqBridgeWeb.MappingJSON do
  alias PgmqBridge.Settings.Mapping

  @doc """
  Renders a list of mappings.
  """
  def index(%{mappings: mappings}) do
    %{data: for(mapping <- mappings, do: data(mapping))}
  end

  @doc """
  Renders a single mapping.
  """
  def show(%{mapping: mapping}) do
    %{data: data(mapping)}
  end

  defp data(%Mapping{} = mapping) do
    %{
      id: mapping.id,
      source_queue: mapping.source_queue,
      sink_queue: mapping.sink_queue,
      local_queue: mapping.local_queue
    }
  end
end
