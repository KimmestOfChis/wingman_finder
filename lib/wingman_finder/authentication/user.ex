defmodule WingmanFinder.Authentication.User do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime_usec]

  import Ecto.Changeset

  alias WingmanFinder.Authentication.Session

  schema "users" do
    field :username, :string
    field :password, :string, redact: true
    field :encrypted_password, :string

    has_one :session, Session

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
  end
end
