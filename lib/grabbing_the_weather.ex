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

  def print_current_weather_message(city) do
    IO.puts("The temperature in #{find_name(city)} today is #{find_current_temperature(city)}ºC, with #{find_current_weather_description(city)}")
  end

  def insert_weather_information(city) do
    GrabbingTheWeather.Repo.insert! %GrabbingTheWeather.WeatherInformation{city: find_name(city), temperature: find_current_temperature(city), description: find_current_weather_description(city)}
  end

  def print_average_temperature(city) do
    IO.puts "The average temperature in #{find_name(city)} is #{
     get_city_temperatures(city)
     |> calculate_average_temperature}ºC"
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

  defp calculate_average_temperature(list_of_temperatures) do
    sum_of_temperatures(list_of_temperatures) / Enum.count(list_of_temperatures)
    |> Float.round(1)
  end

  defp sum_of_temperatures([]), do: 0
  defp sum_of_temperatures([current_temp | next_temps]) do
    current_temp + sum_of_temperatures(next_temps)
  end

  defp find_name(city) do
    parse_json_data(city)["city"]["name"]
  end

  defp find_current_temperature(city) do
    Enum.at(parse_json_data(city)["list"], 0)
    |> locate_temperature
  end

  defp find_current_weather_description(city) do
    Enum.at(parse_json_data(city)["list"], 0)
    |> locate_weather_information
  end

  defp find_tomorrow_temperature(city) do
    Enum.at(parse_json_data(city)["list"], 1)
    |> locate_temperature
  end

  defp locate_weather_information(date_searched) do
    List.first(date_searched["weather"])["description"]
  end

  defp locate_temperature(date_searched) do
    Float.round(date_searched["temp"]["day"], 1)
  end

  defp parse_json_data(city) do
    Poison.Parser.parse!(http_request_data(city))
  end

  defp http_request_data(city) do
   HTTPoison.start
   HTTPoison.get!(create_url(city)).body
  end

  defp remove_spaces(city) do
    String.replace(city, " ", "")
  end

  defp create_url(city) do
    "http://api.openweathermap.org/data/2.5/forecast/daily?q=#{remove_spaces(city)}&mode=json&units=metric&cnt=7&appid=#{System.get_env("WEATHER_API_KEY")}"
  end

end
