defmodule Auroville.ResidenceService do
  use GenServer

  def list_areas() do
    GenServer.call(__MODULE__, :get_areas)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @refresh_interfal 10_000

  def init(_) do
    :timer.send_interval(@refresh_interfal, :refresh)

    {:ok, get_data_from_api([])}
  end

  def handle_call(:get_areas, _from, areas) do
    {:reply, areas, areas}
  end

  def handle_info(:refresh, areas) do
    {:noreply, get_data_from_api(areas)}
  end

  defp get_data_from_api(areas) do
    {:ok, response} = HTTPoison.get("http://api.auroville.org.in/residence")

    case response.status_code do
      200 ->
        Jason.decode!(response.body)
        |> Map.get("data")

      _ ->
        areas
    end
  end
end
