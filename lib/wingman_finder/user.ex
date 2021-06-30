defmodule WingmanFinder.User do
  @moduledoc """
  represents a single human with access to the platform
  """
  use WingmanFinder.Schema

  schema "users" do
    field :email, :string
    field :password, :string, redact: true, virtual: true
    field :password_hash, :string, redact: true
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
  end
end
