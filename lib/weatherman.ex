defmodule Mix.Tasks.Weatherman do
  use Mix.Task
  import GrabbingTheWeather

  def run(city) do
    Application.ensure_all_started(:grabbing_the_weather)
    insert_weather_information(isolate_input(city))
    print_current_weather_message(isolate_input(city))
    print_average_temperature(isolate_input(city))
    print_tomorrow_temperature(isolate_input(city))
  end

  def isolate_input(input) do
    Enum.at(input, 0)
  end

end
