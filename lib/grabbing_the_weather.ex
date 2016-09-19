defmodule GrabbingTheWeather do
  @derive [Poison.Encoder]

  def create_url(city) do
    "http://api.openweathermap.org/data/2.5/weather?q=i#{city}&appid=#{System.get_env("WEATHER_API_KEY")}"
  end

end
