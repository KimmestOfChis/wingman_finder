defmodule WingmanFinder.Authentication do
  @moduledoc """
  deals with user authentication into the system
  """

  import Bcrypt

  alias WingmanFinder.{App, Repo, User}

  # one day
  @token_max_age 86400
  @token_namespace "user auth"

  @doc """
  creates a access_token for the caller to use in subsequent API calls
  """
  @spec create_access_token(App.t(), User.t()) :: String.t()
  def create_access_token(app, user),
    do: Phoenix.Token.sign(signing_salt(), @token_namespace, %{app_id: app.id, user_id: user.id})

  @doc """
  validates that the access_token has not expired and was created by us
  """
  @spec validate_access_token(String.t()) ::
          {:ok, %{user_id: integer(), app_id: integer()}} | {:error, atom()}
  def validate_access_token(access_token),
    do:
      Phoenix.Token.verify(signing_salt(), @token_namespace, access_token, max_age: @token_max_age)

  def get_app(%{"client_id" => client_id, "client_secret" => client_secret}),
    do: Repo.get_by(User, client_id: client_id, client_secret: client_secret)

  def get_user(%{"username" => username}), do: Repo.get_by(User, username: username)

  @doc """
  fetches a user based on username and verifies that the password given matched the hash
  """
  @spec verify_user(params :: map()) :: {:ok, User.t()} | {:error, String.t()}
  def verify_user(%{"password" => password} = params) do
    params
    |> get_user()
    |> check_pass(password)
  end

  def create_session() do
  end

  defp signing_salt, do: Application.fetch_env!(:wingman_finder, :signing_salt)
end
