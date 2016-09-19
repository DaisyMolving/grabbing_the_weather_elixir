defmodule GrabbingTheWeatherTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest GrabbingTheWeather

  test "creates the correct url with environment variable stored key" do
    assert GrabbingTheWeather.create_url("addis ababa") =~ "addisababa"
    assert GrabbingTheWeather.create_url("london") =~ "5a47"
  end

  test "makes http request for json weather data" do
    assert GrabbingTheWeather.http_request_data("london") =~ "weather"
  end

  test "prints message about the weather in chosen city today" do
    assert capture_io(fn ->
      GrabbingTheWeather.print_current_weather_message("addis ababa")
    end) =~ "The weather in Ādīs Ābeba Āstedader today is"
  end
end
