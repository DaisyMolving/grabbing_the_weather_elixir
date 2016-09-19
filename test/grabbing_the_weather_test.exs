defmodule GrabbingTheWeatherTest do
  use ExUnit.Case
  doctest GrabbingTheWeather

  test "creates the correct url with environment variable stored key" do
    assert GrabbingTheWeather.create_url("london") =~ "london"
    assert GrabbingTheWeather.create_url("london") =~ "5a47"
  end

  test "makes http request for json weather data" do
    assert GrabbingTheWeather.http_request_data("london") =~ "weather"
  end

  test "accesses city name and weather description" do
    assert GrabbingTheWeather.find_name_and_description("london") == {"London", "overcast clouds"}
  end
end
