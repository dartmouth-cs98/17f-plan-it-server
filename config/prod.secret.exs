use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :plan_it, PlanIt.Endpoint,
  secret_key_base: "2f/UbU9a7m/fBaxpdxVViLJbYeVyeh3bJapfj2C+UeY8grhIaLBrJr61pT6Wrx76"

# Configure your database
config :plan_it, PlanIt.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "plan_it_prod",
  pool_size: 15
