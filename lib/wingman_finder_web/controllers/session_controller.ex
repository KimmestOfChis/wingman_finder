defmodule WingmanFinderWeb.SessionController do
  use WingmanFinderWeb, :controller

  action_fallback WingmanFinderWeb.FallbackController

  import Inject, only: [i: 1]

  alias WingmanFinder.Authentication

  def create(
        conn,
        %{"username" => _, "password" => _, "client_id" => _, "client_secret" => _} = params
      ) do
    with {:ok, app} <- i(Authentication).get_app(params),
         {:ok, user} <- i(Authentication).verify_user(params),
         {:ok, access_token} <- i(Authentication).create_access_token(app, user) do
      conn
      |> put_status(:created)
      |> render("show.json", access_token: access_token)
    end
  end

  def create(conn, _params) do
    conn |> put_status(400) |> render("missing_create_param.json", [])
  end
end
