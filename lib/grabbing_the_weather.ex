defmodule GrabbingTheWeather do
  @derive [Poison.Encoder]
  require HTTPoison

  def find_name_and_description(city) do
    {find_name(city), find_weather_description(city)}
  end

  def find_weather_description(city) do
    find_key_from_body(city, "weather")
    |> List.first
    |> Map.fetch!("description")
  end

  def find_name(city) do
    find_key_from_body(city, "name")
  end

  def find_key_from_body(city, key) do
    Poison.Parser.parse!(http_request_data(city))
    |> Map.fetch!(key)
  end

  def http_request_data(city) do
   HTTPoison.start
   HTTPoison.get!(create_url(city)).body
  end

  def create_url(city) do
    "http://api.openweathermap.org/data/2.5/weather?q=i#{city}&appid=#{System.get_env("WEATHER_API_KEY")}"
  end

end
