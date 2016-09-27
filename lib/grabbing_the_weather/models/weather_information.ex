defmodule GrabbingTheWeather.WeatherInformation do
  use Ecto.Schema

  schema "weather_information" do
    timestamps
    field :city, :string
    field :temperature, :float
    field :description, :string
  end

end
