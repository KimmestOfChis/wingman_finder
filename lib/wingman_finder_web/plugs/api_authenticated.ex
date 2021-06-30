defmodule WingmanFinder.Plug.ApiAuthenticated do
  @behaviour Plug

  import Inject, only: [i: 1]
  import Plug.Conn, only: [assign: 3, get_req_header: 2, halt: 1, put_status: 2]
  import Phoenix.Controller, only: [json: 2]

  alias WingmanFinder.Auth.{Authentication, Session}
  alias WingmanFinder.{App, User}

  @auth_header_key "authorization"

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, _params) do
    with {:ok, token} <- validate_auth_header(conn),
         {:ok, %{app_id: app_id, user_id: user_id}} <- i(Session).validate_access_token(token),
         %App{} = app <- i(Authentication).get_app(app_id),
         %User{} = user <- i(Authentication).get_user(user_id) do
      conn
      |> assign(:current_user, user)
      |> assign(:current_app, app)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{"error" => "you must be authenticated to access this resource"})
        |> halt()
    end
  end

  defp validate_auth_header(conn) do
    case get_req_header(conn, @auth_header_key) do
      ["Bearer " <> token] -> {:ok, token}
      _ -> {:error, :invalid_or_missing_auth_header}
    end
  end
end
