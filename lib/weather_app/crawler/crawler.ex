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
    |> WeatherApp.Mongo.save
  end
  def create_measurement(value) do
    current_date = Timex.now("America/Sao_Paulo") |> Timex.format!("{ISO:Extended}")
    %Measurement{date_time: current_date, weather_data: value}
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
        Map.put(attr_map, normalize_string(attr_name), normalize_value(attr_value))
      end)
  end

  defp normalize_value(value) do
    value_without_comma = value
      |> normalize_string
      |> String.replace(",", ".")
    Regex.replace(~r/[^0-9.NSEO]+/, value_without_comma, "")
  end

  def normalize_string(raw) do
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
   end
end
