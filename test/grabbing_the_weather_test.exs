defmodule GrabbingTheWeatherTest do
  use ExUnit.Case
  doctest GrabbingTheWeather

  test "creates the correct url with environment variable stored key" do
    assert GrabbingTheWeather.create_url("london") =~ "london"
    assert GrabbingTheWeather.create_url("london") =~ "5a47"
  end
end
