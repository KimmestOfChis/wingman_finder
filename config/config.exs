# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :wingman_finder, App.Repo, migration_timestamps: [type: :utc_datetime]

config :wingman_finder,
  ecto_repos: [WingmanFinder.Repo],
  token_signing_salt: "super secret"

# Configures the endpoint
config :wingman_finder, WingmanFinderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "coW+X3h5WLLaIDnzWAUyfvkv3zkBYqSpIU+pnK+Qm/4fvEC7UdYGLVrfn5oXaSRO",
  render_errors: [view: WingmanFinderWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: WingmanFinder.PubSub,
  live_view: [signing_salt: "tjwntJbq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
