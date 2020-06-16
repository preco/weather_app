defmodule WeatherAppWeb.InfoController do
  use WeatherAppWeb, :controller

  def show_last(conn, _params) do
    pretty_json(conn, WeatherApp.MeasurementService.get_last_measurement_map)
  end

  defp pretty_json(conn, data) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json; charset=utf-8")
    |> Plug.Conn.send_resp(200, Poison.encode!(data, pretty: true))
  end
end
