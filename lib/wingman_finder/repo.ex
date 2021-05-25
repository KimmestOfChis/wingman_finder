defmodule WingmanFinder.Repo do
  use Ecto.Repo,
    otp_app: :wingman_finder,
    adapter: Ecto.Adapters.Postgres
end
