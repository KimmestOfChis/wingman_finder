defmodule WingmanFinder.Auth.Session do
  @moduledoc """
  collection of functions dealing with sessions and their bookkeeping
  """

  import Inject, only: [i: 1]

  alias Ecto.Changeset

  alias WingmanFinder.{App, Repo, User}
  alias WingmanFinder.Session, as: SessionStruct

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
  def validate_access_token(access_token) do
    with {:ok, %{app_id: app_id, user_id: user_id}} <-
           Phoenix.Token.verify(signing_salt(), @token_namespace, access_token,
             max_age: @token_max_age
           ),
         %SessionStruct{} <-
           i(__MODULE__).get_session(app_id: app_id, user_id: user_id, token: access_token) do
      {:ok, %{app_id: app_id, user_id: user_id}}
    end
  end

  @doc """
  retreives the current session and destroys it
  """
  @spec clear_current_session(App.t(), User.t()) ::
          {:ok, %SessionStruct{}} | {:error, Changeset.t()}
  def clear_current_session(app, user),
    do:
      [app_id: app.id, user_id: user.id]
      |> get_session()
      |> delete_session()

  @doc """
  destroys the session
  """
  @spec delete_session(nil | SessionStruct.t()) ::
          {:ok, nil | SessionStruct.t()} | {:error, Changeset.t()}
  def delete_session(nil), do: {:ok, nil}
  def delete_session(%SessionStruct{} = session), do: Repo.delete(session)

  @doc """
  fetches a session based on the passed opts

  opts should be the keys for %SessionStruct{}
  """
  @spec get_session(list()) :: SessionStruct.t() | nil
  def get_session(opts) when is_list(opts), do: Repo.get_by(SessionStruct, opts)
  def get_session(_), do: nil

  @doc """
  saves the session for the app/user/token
  """
  @spec create_session(App.t(), User.t(), String.t()) ::
          {:ok, SessionStruct.t()} | {:error, Changeset.t()}
  def create_session(app, user, token) do
    %SessionStruct{}
    |> SessionStruct.changeset(%{
      app_id: app.id,
      user_id: user.id,
      token: token
    })
    |> Repo.insert()
  end

  defp signing_salt, do: Application.fetch_env!(:wingman_finder, :token_signing_salt)
end
