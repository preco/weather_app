defmodule WeatherApp.Repo.Migrations.CreateInfos do
  use Ecto.Migration

  def change do
    create table(:infos) do
      add :date_time, :string
      add :weather_data, :map

      timestamps()
    end

  end
end
