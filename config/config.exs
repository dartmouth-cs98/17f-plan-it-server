# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :plan_it,
  ecto_repos: [PlanIt.Repo]

# Configures the endpoint
config :plan_it, PlanIt.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jV08mH+HVsBnXYwx/DiGi0+ndiThxM3c+PtCsswIFLWPB1gYGndTbdlWLZb1hP4y",
  render_errors: [view: PlanIt.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PlanIt.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
