use Mix.Config

# General application configuration
config :plan_it,
  ecto_repos: [PlanIt.Repo]

# Configure your database
config :plan_it, PlanIt.Repo,
#  adapter: Ecto.Adapters.Postgres,
#  username: "postgres",
#  password: "postgres",
#  database: "postgresql-pointy-80927",
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

# Configures the endpoint
config :plan_it, PlanIt.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "plan-it-server.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")
#  render_errors: [view: PlanIt.ErrorView, accepts: ~w(html json)],
#  pubsub: [name: PlanIt.PubSub,
#           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
