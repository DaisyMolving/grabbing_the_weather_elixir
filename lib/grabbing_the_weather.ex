defmodule GrabbingTheWeather do
  use Application
  @derive [Poison.Encoder]
  require HTTPoison

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(GrabbingTheWeather.Repo, [])
      # Starts a worker by calling: GlobalWeatherService.Worker.start_link(arg1, arg2, arg3)
      # worker(GlobalWeatherService.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GrabbingTheWeather.Supervisor]
    Supervisor.start_link(children, opts)
  end

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
