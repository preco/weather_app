use Mix.Config

config :weather_app, WeatherAppWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("APP_NAME")<> ".gigalixirapp.com", port: 80],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  server:true

config :logger, level: :info

import_config "prod.secret.exs"
