use Mix.Config

# General application configuration
config :plan_it,
  ecto_repos: [PlanIt.Repo]

# Configure your database
config :plan_it, PlanIt.Repo,
  adapter: Ecto.Adapters.Postgres,
#  username: "postgres",
#  password: "postgres",
#  database: "postgresql-pointy-80927",
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true


# General application configuration
config :plan_it,
  ecto_repos: [PlanIt.Repo]

# Configures the endpoint
config :plan_it, PlanIt.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "plan-it-server.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
#  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")
#  render_errors: [view: PlanIt.ErrorView, accepts: ~w(html json)],
#  pubsub: [name: PlanIt.PubSub,
#           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]



config :plan_it, PlanIt.Endpoint,
  http: [port: 443],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :plan_it, PlanIt.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

#yelp api
# config :yelp,
# id: "CYQN92eKQPcAzMpfGvDknA",
# secret: "sJ3mr4cd3TGZmJ9x1icWJdxpgPqELci5pRDDeYHJME9S4SBiKy16XtB2hJo7iXvu"

# put OAuth2 debug mode
config :oauth2,
  debug: true

import_config "#{Mix.env}.exs"
