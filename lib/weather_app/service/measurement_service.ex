defmodule WeatherApp.MeasurementService do
  import Ecto.Query, only: [from: 2]

  defp get_last_measurement() do
    WeatherApp.Repo.one!(from m in WeatherApp.Measurement, order_by: [desc: :measured_at], limit: 1)
  end

  defp remove_non_visible_attributes(map) do
    Map.drop(map, [:__meta__])
    |> Map.drop([:id])
  end

  defp convert_date_time(map) do
    map
    |> Enum.map(fn {k, v} -> {k, shift_zone(v)} end)
    |> Enum.into(%{})

  end

  defp shift_zone(value) do
    case value do
      value when is_struct(value) -> DateTime.shift_zone!(value, "America/Sao_Paulo")
      _ -> value
    end
  end

  def get_last_measurement_json() do
    get_last_measurement()
    |> Map.from_struct
    |> remove_non_visible_attributes
    |> convert_date_time
  end

end
