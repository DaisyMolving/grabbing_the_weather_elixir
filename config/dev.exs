use Mix.Config

config :grabbing_the_weather, GrabbingTheWeather.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "grabbing_the_weather_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :logger, level: :error
