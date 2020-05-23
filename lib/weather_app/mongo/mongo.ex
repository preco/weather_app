defmodule WeatherApp.Mongo do
  require Mongo

  def save(value) do
    {:ok, conn} = Mongo.start_link(
      url: "mongodb+srv://perereco:5cwjqKnWPfirV8Y@clustereco-havvp.gcp.mongodb.net",
      database: "weather_app",
      show_sensitive_data_on_connection_error: true
      )
    Mongo.insert_one(conn, "weather_measurements", value)
  end
end
