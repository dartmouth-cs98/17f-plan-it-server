use Mix.Config

# General application configuration
config :plan_it,
  ecto_repos: [PlanIt.Repo]

# Configure your database
#config :plan_it, PlanIt.Repo,
#  adapter: Ecto.Adapters.Postgres,
#  username: "postgres",
#  password: "postgres",
#  database: "postgresql-pointy-80927",
#  url: System.get_env("DATABASE_URL"),
#  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
#  ssl: true
