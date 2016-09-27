use Mix.Config

config :grabbing_the_weather, GrabbingTheWeather.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "grabbing_the_weather_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

