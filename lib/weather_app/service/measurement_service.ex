defmodule WeatherApp.MeasurementService do
  import Ecto.Query, only: [from: 2]

  defp get_last_measurement() do
    WeatherApp.Repo.one!(from m in WeatherApp.Measurement, order_by: [desc: :measured_at], limit: 1)
  end

  defp remove_non_visible_attributes(map) do
    Map.drop(map, [:__meta__])
    |> Map.drop([:id])
  end

  defp shift_zone_from_datetime_attributes(map) do
    map
    |> Enum.map(fn {k, v} -> {k, shift_zone(v)} end)
    |> Enum.into(%{})

  end

  defp shift_zone(value) do
    if is_a_datetime? value do
      DateTime.shift_zone!(value, "America/Sao_Paulo")
    else
      value
    end
  end

  defp is_a_datetime?(%DateTime{}) do
    true
  end

  defp is_a_datetime?(_) do
    false
  end
  @doc """
  Busca o registro que possuir a data de medição mais atual,
  converte em um mapa de atributos,
  remove os atributos que não correspondem a dados
  e muda o fuso horário das datas para o horário de Brasília
  """
  def get_last_measurement_map() do
    get_last_measurement()
    |> Map.from_struct
    |> remove_non_visible_attributes
    |> shift_zone_from_datetime_attributes
  end

end
