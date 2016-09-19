defmodule GrabbingTheWeatherTest do
  use ExUnit.Case
  doctest GrabbingTheWeather

  test "creates the correct url with environment variable stored key" do
    assert GrabbingTheWeather.create_url("london") =~ "london"
    assert GrabbingTheWeather.create_url("london") =~ "5a47"
  end

  test "makes http request for json weather data" do
    assert Map.has_key?(GrabbingTheWeather.http_request_data("london"), :body)
  end
end
