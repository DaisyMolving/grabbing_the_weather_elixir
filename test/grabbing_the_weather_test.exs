defmodule GrabbingTheWeatherTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GrabbingTheWeather.Repo)
  end

  test "prints message about the weather in chosen city today" do
    assert capture_io(fn ->
      GrabbingTheWeather.print_current_weather_message("london")
    end) =~ "The temperature in London today is "
  end

  test "takes average temperature from list of temperatures" do
    assert GrabbingTheWeather.calculate_average_temperature([19.2, 19.8, 18.6]) == 19.2
  end

  test "prints average temperature in given city" do
    GrabbingTheWeather.Repo.insert! %GrabbingTheWeather.WeatherInformation{
      city: "London", 
      temperature: 18.5, 
      description: "cloudy skies"}

    assert capture_io(fn ->
      GrabbingTheWeather.print_average_temperature("london")
    end) =~ "The average temperature in London is 18.5ºC" 
  end

  test "prints tomorrow's temperature in given city" do
    assert capture_io(fn ->
      GrabbingTheWeather.print_tomorrow_temperature("london")
    end) =~ "Tomorrow, the temperature in London will be" 
  end

end
