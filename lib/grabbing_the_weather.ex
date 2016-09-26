defmodule GrabbingTheWeather do
  use Application
  @derive [Poison.Encoder]
  import Ecto.Query, only: [from: 2]
  require HTTPoison

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(GrabbingTheWeather.Repo, [])
    ]
    opts = [strategy: :one_for_one, name: GrabbingTheWeather.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def insert_weather_information(city) do
    GrabbingTheWeather.Repo.insert! %GrabbingTheWeather.WeatherInformation{city: find_name(city), temperature: find_current_temperature(city), description: find_weather_description(city)}
  end

  def print_average_temperature(city) do
    IO.puts "The average temperature in #{find_name(city)} is #{
     get_city_temperatures(city)
     |> get_average_temperature}ºC"
  end

  def print_tomorrow_temperature(city) do
    IO.puts("Tomorrow, the temperature in #{find_name(city)} will be #{find_tomorrow_temperature(city)}")
  end

  def get_city_temperatures(city) do
    query = from w in "weather_information", 
            where: w.city == ^find_name(city),
            select: w.temperature
    GrabbingTheWeather.Repo.all(query)
  end

  def get_average_temperature(list_of_temperatures) do
    sum_of_temperatures(list_of_temperatures) / Enum.count(list_of_temperatures)
    |> Float.round(1)
  end

  defp sum_of_temperatures([]), do: 0
  defp sum_of_temperatures([current_temp | next_temps]) do
    elem(Float.parse(current_temp), 0) + sum_of_temperatures(next_temps)
  end

  def print_current_weather_message(city) do
    IO.puts("The temperature in #{find_name(city)} today is #{find_current_temperature(city)}ºC, with #{find_weather_description(city)}")
  end

  def http_request_data(city) do
   HTTPoison.start
   HTTPoison.get!(create_url(city)).body
  end

  def create_url(city) do
    "http://api.openweathermap.org/data/2.5/forecast/daily?q=#{remove_spaces(city)}&mode=json&units=metric&cnt=7&appid=#{System.get_env("WEATHER_API_KEY")}"
  end

  defp find_tomorrow_temperature(city) do
    locate_temperature(city, 1)
  end

  defp find_current_temperature(city) do
    locate_temperature(city, 0)
  end

  defp find_weather_description(city) do
    find_key_from_body(city, "list")
    |> Enum.at(0)
    |> Map.fetch!("weather")
    |> List.first
    |> Map.fetch!("description")
  end

  defp locate_temperature(city, day) do
    find_key_from_body(city, "list")
    |> Enum.at(day)
    |> Map.fetch!("temp")
    |> Map.fetch!("day")
    |> Float.round(1)
  end

  defp find_name(city) do
    find_key_from_body(city, "city")["name"]
  end

  defp find_key_from_body(city, key) do
    Poison.Parser.parse!(http_request_data(city))
    |> Map.fetch!(key)
  end

  defp remove_spaces(city) do
    String.replace(city, " ", "")
  end

end
