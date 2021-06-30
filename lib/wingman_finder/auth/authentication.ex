defmodule WingmanFinder.Auth.Authentication do
  @moduledoc """
  deals with user authentication into the system
  """
  import Inject, only: [i: 1]

  alias WingmanFinder.{App, Repo, User}

  @spec get_app(list()) :: App.t() | nil
  def get_app(opts), do: i(Repo).get_by(App, opts)

  @spec get_user(list()) :: User.t() | nil
  def get_user(opts), do: i(Repo).get_by(User, opts)

  @doc """
  fetches a user based on username and verifies that the password given matched the hash
  """
  @spec verify_user(String.t(), String.t()) :: {:ok, map()} | {:error, String.t()}
  def verify_user(username, password) do
    [username: username]
    |> get_user()
    |> i(Bcrypt).check_pass(password)
  end

  @doc """
  hashes the given password using bcrypt
  """
  @spec hash_password(String.t()) :: %{password_hash: String.t()}
  def hash_password(password), do: i(Bcrypt).add_hash(password)
end
