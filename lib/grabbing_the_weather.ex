defmodule GrabbingTheWeather do
  @derive [Poison.Encoder]
  require HTTPoison

  def http_request_data(city) do
   HTTPoison.start
   HTTPoison.get!(create_url(city))
  end

  def create_url(city) do
    "http://api.openweathermap.org/data/2.5/weather?q=i#{city}&appid=#{System.get_env("WEATHER_API_KEY")}"
  end

end
