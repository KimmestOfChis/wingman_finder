defmodule WingmanFinder.Auth.Authentication do
  @moduledoc """
  deals with user authentication into the system
  """
  alias Ecto.Changeset

  alias WingmanFinder.{App, Repo, User}

  @spec get_app(map()) :: {:ok, App.t()} | {:error, Changeset.t()}
  def get_app(%{"client_id" => client_id, "client_secret" => client_secret}),
    do: Repo.get_by(App, client_id: client_id, client_secret: client_secret)

  @spec get_app(integer()) :: {:ok, App.t()} | {:error, Changeset.t()}
  def get_app(id) when is_integer(id),
    do: Repo.get(App, id)

  @spec get_user(integer() | map()) :: {:ok, User.t()} | {:error, Changeset.t()}
  def get_user(id) when is_integer(id),
    do: Repo.get(User, id)

  def get_user(%{"username" => username}), do: Repo.get_by(User, username: username)

  @doc """
  fetches a user based on username and verifies that the password given matched the hash
  """
  @spec verify_user(params :: map()) :: {:ok, User.t()} | {:error, String.t()}
  def verify_user(%{"password" => password} = params) do
    params
    |> get_user()
    |> Bcrypt.check_pass(password)
  end

  @doc """
  hashes the given password using bcrypt
  """
  @spec hash_password(String.t()) :: %{password_hash: String.t()}
  def hash_password(password), do: Bcrypt.add_hash(password)
end
