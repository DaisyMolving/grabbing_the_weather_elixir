use Mix.Config

config :grabbing_the_weather, ecto_repos: [GrabbingTheWeather.Repo]

import_config "#{Mix.env}.exs"
