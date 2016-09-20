defmodule GrabbingTheWeather do
  @derive [Poison.Encoder]
  require HTTPoison

  def print_current_weather_message(city) do
    IO.puts("The temperature in #{find_name(city)} today is #{find_temperature(city)}, with #{find_weather_description(city)}")
  end

  def http_request_data(city) do
   HTTPoison.start
   HTTPoison.get!(create_url(city)).body
  end

  def create_url(city) do
    "http://api.openweathermap.org/data/2.5/weather?q=i#{remove_spaces(city)}&appid=#{System.get_env("WEATHER_API_KEY")}"
  end

  defp find_temperature(city) do
    find_key_from_body(city, "main")["temp"]
    |> convert_kelvin_to_celsius
  end

  defp convert_kelvin_to_celsius(kelvin_temp) do
    "#{Float.round(kelvin_temp - 273.15, 1)}ºC"
  end

  defp find_weather_description(city) do
    find_key_from_body(city, "weather")
    |> List.first
    |> Map.fetch!("description")
  end

  defp find_name(city) do
    find_key_from_body(city, "name")
  end

  defp find_key_from_body(city, key) do
    Poison.Parser.parse!(http_request_data(city))
    |> Map.fetch!(key)
  end

  defp remove_spaces(city) do
    String.replace(city, " ", "")
  end

end
