require Protocol
Protocol.derive(Jason.Encoder, BSON.ObjectId)
defmodule WeatherApp.Mongo do
  require Mongo

  def save(value) do
    start()
    |> Mongo.insert_one("weather_measurements", value)
  end

  def get_last() do
    start()
    |> Mongo.find("weather_measurements", %{}, limit: 1, sort: %{date_time: -1})
    |> Enum.to_list()
    |> Enum.at(0)
    |> to_struct(Measurement)
  end

  defp start() do
    {:ok, conn} = Mongo.start_link(
      url: "mongodb+srv://perereco:5cwjqKnWPfirV8Y@clustereco-havvp.gcp.mongodb.net",
      database: "weather_app",
      show_sensitive_data_on_connection_error: true
      )
    conn
  end

  defp to_struct(attrs, kind) do
    struct = struct(kind)
    Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end
end
