defmodule WingmanFinder.App do
  @moduledoc """
  represents a non-human user in the system.

  these will likly perform actions on behalf of `WingmanFinder.Users`s
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "apps" do
    field :api_key, :string
    field :api_secret, :string, react: true
    field :display_name, :string

    timestamps()
  end

  @doc false
  def changeset(app, attrs) do
    app
    |> cast(attrs, [:api_key, :api_secret, :display_name])
    |> validate_required([:api_key, :api_secret, :display_name])
  end
end
