defmodule GrabbingTheWeather.Mixfile do
  use Mix.Project

  def project do
    [app: :grabbing_the_weather,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison, :postgrex, :ecto],
     mod: {GrabbingTheWeather, []}]
  end

  defp deps do
    [ {:poison, "~> 2.0"}, 
      {:httpoison, "~> 0.9.0"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.0.0"}
    ]
  end

end
