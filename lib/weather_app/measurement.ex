defmodule WeatherApp.Measurement do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  schema "measurements" do
    field :measured_at, :utc_datetime
    field :temperature, :float
    field :humidity, :float
    field :atmospheric_pressure, :float
    field :wind_speed, :float
    field :wind_direction, :string
    field :river_level, :float
    timestamps()
  end

  @doc false
  def changeset(measurement, attrs) do
    measurement
    |> cast(attrs, [])
    |> validate_required([])
  end

  def convert_name(name) do
    case name do
      "Temperatura" -> :temperature
      "Umidade relativa do ar" -> :humidity
      "Pressão atmosférica" -> :atmospheric_pressure
      "Velocidade do vento" -> :wind_speed
      "Direção do vento" -> :wind_direction
      "Nível do Rio Tubarão" -> :river_level
      _ -> name
    end
  end
  def convert_value(value, attr) do
    case attr do
      :wind_direction -> value
      _ -> parse_float(value)
    end
  end

  defp parse_float(value) do
    {parsed, _} = Float.parse(value)
    parsed
  end
end
