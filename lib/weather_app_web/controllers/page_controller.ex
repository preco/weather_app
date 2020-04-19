defmodule WeatherAppWeb.PageController do
  use WeatherAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
