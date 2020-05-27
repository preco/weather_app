defmodule WeatherAppWeb.Router do
  use WeatherAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WeatherAppWeb do
    pipe_through :browser

    get "/", DefaultController, :index
  end

  scope "/api", WeatherAppWeb do
     pipe_through :api
     get "/last", InfoController, :show_last
     get "/interval", InfoController, :show_interval
  end
end
