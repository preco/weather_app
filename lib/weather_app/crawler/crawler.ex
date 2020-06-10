defmodule WeatherApp.Crawler do
  require Logger

  @moduledoc false
  def get_url_info() do
    Logger.info("Iniciando crawler")
    url = "http://www.plantaragronomia.eng.br/"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        handle_table_info(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.info "Not found"
      {_, %HTTPoison.Response{status_code: 500}} ->
        get_url_info()
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp handle_table_info(body) do
    body
    |> get_table_info
    |> create_measurement
    |> save
  end
  defp create_measurement(measurement_map) do
    measured_at = DateTime.utc_now |> DateTime.truncate(:second)
    measurement = struct(%WeatherApp.Measurement{}, measurement_map)
    %{measurement | measured_at: measured_at}
  end


  defp save(measurement) do
    WeatherApp.Repo.insert(measurement)
  end

  defp get_table_info(body) do
    body
      |> Floki.find("table.table_estacao")
      |> Floki.find("tr")
      |> Enum.reduce(Map.new, fn(column, attr_map) ->
        {_, [_],
        [{_,_, [attr_name]},
        {_, _, [attr_value]}]
        } = column
        Map.put(attr_map, convert_name(attr_name), convert_value(attr_name, attr_value))
      end)
  end

  defp convert_name(name) do
    name
    |> normalize_string
    |> WeatherApp.Measurement.convert_name
  end

  defp convert_value(name, value) do
    attr = convert_name(name)
    value
    |> normalize_value
    |> WeatherApp.Measurement.convert_value(attr)
  end

  defp normalize_value(value) do
    value_without_comma = value
      |> normalize_string
      |> String.replace(",", ".")
    Regex.replace(~r/[^0-9.NSEO]+/, value_without_comma, "")
  end

  defp normalize_string(raw) do
    codepoints = String.codepoints(raw)
    Enum.reduce(codepoints,
      fn(w, result) ->
        cond do
          String.valid?(w) ->
            result <> w
          true ->
            << parsed :: 8>> = w
            result <>   << parsed :: utf8 >>
        end
      end)
      |> String.trim
  end
end
