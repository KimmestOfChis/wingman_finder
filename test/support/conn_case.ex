defmodule WingmanFinderWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use WingmanFinderWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  import Plug.Conn
  import WingmanFinder.Factory

  alias WingmanFinder.Auth.Session

  @auth_header_key "authorization"

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import WingmanFinderWeb.ConnCase

      alias WingmanFinderWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint WingmanFinderWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(WingmanFinder.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(WingmanFinder.Repo, {:shared, self()})
    end

    user = insert(:user)
    app = insert(:app)

    conn = Phoenix.ConnTest.build_conn() |> with_auth_token(app, user)

    {:ok, conn: conn, user: user, app: app}
  end

  defp with_auth_token(conn, app, user) do
    token = Session.create_access_token(app, user)

    insert(:session, %{user: user, app: app, token: token})

    conn |> put_req_header(@auth_header_key, "Bearer #{token}")
  end
end
