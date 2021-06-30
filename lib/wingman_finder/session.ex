defmodule WingmanFinder.Session do
  use Ecto.Schema
  import Ecto.Changeset

  alias WingmanFinder.{App, User}

  schema "sessions" do
    field :token, :string

    belongs_to :user, User
    belongs_to :app, App

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:token, :user_id, :app_id])
    |> validate_required([:token, :user_id, :app_id])
  end
end
