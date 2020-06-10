# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :weather_app, WeatherApp.Repo,
  database: "perereco_weather",
  username: "perereco_weather_user",
  password: "YPVg9SREwLrp8jd",
  hostname: "localhost"

# Configures the endpoint
config :weather_app, WeatherAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9v6coKvB5m6N4f4lEDNIN9ycaFtGkHaDt8/Cb65Xnj5Pb6k1lFXVJ6YUw1Li7VlA",
  render_errors: [view: WeatherAppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WeatherApp.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "SB94hKTt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures scheduler
config :weather_app, WeatherApp.Scheduler,
  jobs: [
    # Every 60 minutes
    {"*/60 * * * *",   fn -> WeatherApp.Crawler.get_url_info end},
  ]

config :weather_app,
  ecto_repos: [WeatherApp.Repo]
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
