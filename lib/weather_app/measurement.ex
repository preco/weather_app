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
end
