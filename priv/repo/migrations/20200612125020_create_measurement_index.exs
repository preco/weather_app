defmodule WeatherApp.Repo.Migrations.CreateMeasurementIndex do
  use Ecto.Migration

  def change do
    create index(:measurements, [:measured_at])
  end
end
