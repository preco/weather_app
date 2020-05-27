defmodule WeatherAppWeb.DefaultController do
  use WeatherAppWeb, :controller

  def index(conn, _params) do
    text conn, "BusiApi!"
  end
end
