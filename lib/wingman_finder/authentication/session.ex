defmodule WingmanFinder.Authentication.Session do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime_usec]

  import Ecto.Changeset

  alias WingmanFinder.Authentication.User

  schema "sessions" do
    field :jwt, :string
    field :expires_at, :utc_datetime_usec

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:jwt, :expires_at, :user_id])
    |> validate_required([:jwt, :expires_at, :user_id])
  end
end
