defmodule GrabbingTheWeatherTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "creates the correct url with environment variable stored key" do
    assert GrabbingTheWeather.create_url("addis ababa") =~ "addisababa"
    assert GrabbingTheWeather.create_url("london") =~ "5a47"
  end

  test "makes http request for json weather data" do
    assert GrabbingTheWeather.http_request_data("london") =~ "weather"
  end

  test "prints message about the weather in chosen city today" do
    assert capture_io(fn ->
      GrabbingTheWeather.print_current_weather_message("london")
    end) =~ "The temperature in London today is "
  end

  test "takes average temperature from list of temperatures" do
    assert GrabbingTheWeather.get_average_temperature([19.2, 19.8, 18.6]) == 19.2
  end

  test "prints average temperature in given city" do
    assert capture_io(fn ->
      GrabbingTheWeather.print_average_temperature("london")
    end) =~ "The average temperature in London is" 
  end

  test "prints tomorrow's temperature in given city" do
    assert capture_io(fn ->
      GrabbingTheWeather.print_tomorrow_temperature("london")
    end) =~ "Tomorrow, the temperature in London will be" 
  end

end
