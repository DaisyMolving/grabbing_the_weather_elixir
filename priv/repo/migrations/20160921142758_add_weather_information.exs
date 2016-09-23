defmodule GrabbingTheWeather.Repo.Migrations.AddWeatherInformation do
  use Ecto.Migration

  def change do
    create table(:weather_information) do
      add :city, :string
      add :temperature, :string
      add :description, :string

      timestamps
    end

  end
end
