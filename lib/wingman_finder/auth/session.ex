defmodule WingmanFinder.Auth.Session do
  alias WingmanFinder.{App, Session, User}

  alias WingmanFinder.{Repo, Session}

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

  @doc """
  retreives the current session and destroys it
  """
  def clear_current_session(app, user),
    do:
      app
      |> get_session(user)
      |> delete_session()

  @spec delete_session(nil | Session.t()) :: {:ok, nil | Session.t()} | {:error, Changeset.t()}
  def delete_session(nil), do: {:ok, nil}
  def delete_session(session), do: Repo.delete(session)

  def get_session(app, user), do: Repo.get_by(Session, app_id: app.id, user_id: user.id)

  @doc """
  saves the session for the app/user/token
  """
  @spec save_session(App.t(), User.t(), String.t()) ::
          {:ok, Session.t()} | {:error, Changeset.t()}
  def save_session(app, user, token) do
    %Session{}
    |> Session.changeset(%{
      app_id: app.id,
      user_id: user.id,
      token: token
    })
    |> Repo.insert()
  end

  defp signing_salt, do: Application.fetch_env!(:wingman_finder, :token_signing_salt)
end
