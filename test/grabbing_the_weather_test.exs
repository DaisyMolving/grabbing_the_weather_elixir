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

  test "retrieves temperatures from the database" do
    GrabbingTheWeather.Repo.insert! %GrabbingTheWeather.WeatherInformation{
      city: "London",
      temperature: 30.0, 
      description: "Sunny"
    }
    GrabbingTheWeather.Repo.insert! %GrabbingTheWeather.WeatherInformation{
      city: "London",
      temperature: 18.5,
      description: "Cloudy"
    }
    GrabbingTheWeather.Repo.insert! %GrabbingTheWeather.WeatherInformation{
      city: "London",
      temperature: 10.5,
      description: "Light Rain"
    }

    assert GrabbingTheWeather.get_city_temperatures("london") == [30.0, 18.5, 10.5]
  end

  test "prints average temperature in given city" do
    GrabbingTheWeather.Repo.insert! %GrabbingTheWeather.WeatherInformation{
      city: "London",
      temperature: 30.0, 
      description: "Sunny"
    }
    GrabbingTheWeather.Repo.insert! %GrabbingTheWeather.WeatherInformation{
      city: "London",
      temperature: 18.5,
      description: "Cloudy"
    }
    GrabbingTheWeather.Repo.insert! %GrabbingTheWeather.WeatherInformation{
      city: "London",
      temperature: 10.5,
      description: "Light Rain"
    }

    assert capture_io(fn ->
      GrabbingTheWeather.print_average_temperature("london")
    end) =~ "The average temperature in London is 19.7ºC" 
  end

  test "prints tomorrow's temperature in given city" do
    assert capture_io(fn ->
      GrabbingTheWeather.print_tomorrow_temperature("london")
    end) =~ "Tomorrow, the temperature in London will be" 
  end

end
