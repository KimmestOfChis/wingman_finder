defmodule WingmanFinder.Auth.Authentication do
  @moduledoc """
  deals with user authentication into the system
  """

  import Bcrypt

  alias Ecto.Changeset

  alias WingmanFinder.{App, Repo, User}

  @spec get_app(map()) :: {:ok, App.t()} | {:error, Changeset.t()}
  def get_app(%{"client_id" => client_id, "client_secret" => client_secret}),
    do: Repo.get_by(User, client_id: client_id, client_secret: client_secret)

  @doc """
  fetches a user based on username and verifies that the password given matched the hash
  """
  @spec verify_user(params :: map()) :: {:ok, User.t()} | {:error, String.t()}
  def verify_user(%{"password" => password} = params) do
    params
    |> get_user()
    |> check_pass(password)
  end

  @doc """
  hashes the given password using bcrypt
  """
  def hash_password(password), do: add_hash(password)

  defp get_user(%{"username" => username}), do: Repo.get_by(User, username: username)
end
