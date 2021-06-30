defmodule WingmanFinderWeb.SessionControllerTest do
  use WingmanFinderWeb.ConnCase

  import Double, only: [stub: 3]
  import Inject, only: [register: 2]

  import WingmanFinder.Factory

  alias WingmanFinder.Auth.{Authentication, Session}

  @access_token "token"

  @session_params %{
    "username" => "username",
    "password" => "password",
    "client_id" => "client_id",
    "client_secret" => "client_secret"
  }

  @ecto_error {:error, %Ecto.Changeset{}}

  describe "/login" do
    setup [:setup_authentication_stub, :setup_session_stub]

    test "it returns an access token", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.session_path(conn, :create), @session_params)

      assert {:ok, %{"access_token" => @access_token}} = Jason.decode(resp_body)
    end

    @tag get_app_result: nil
    test "when the app cannot be verified, it does not return a token", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.session_path(conn, :create), @session_params)

      assert {:ok, %{"access_token" => @access_token}} = Jason.decode(resp_body)
    end

    @tag verify_user_result: {:error, "blew up"}
    test "when the user cannot be verified, it does not return a token", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.session_path(conn, :create), @session_params)

      assert {:ok, %{"error" => "blew up"}} = Jason.decode(resp_body)
    end

    @tag create_access_token_result: {:error, :blew_up}
    test "when token creation fails, it does not return a token", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.session_path(conn, :create), @session_params)

      assert {:ok, %{"error" => "blew_up"}} = Jason.decode(resp_body)
    end

    @tag clear_current_session_result: @ecto_error
    test "when clearing the current session fails, it does not return a token", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.session_path(conn, :create), @session_params)

      assert {:ok, %{"errors" => []}} = Jason.decode(resp_body)
    end

    @tag save_session_result: @ecto_error
    test "when saving the session fails, it does not return a token", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.session_path(conn, :create), @session_params)

      assert {:ok, %{"errors" => []}} = Jason.decode(resp_body)
    end

    for {key, _value} <- @session_params do
      @tag param_key: key
      test "#{key} is required", %{conn: conn, param_key: param_key} do
        {_value, invalid_params} = Map.pop(@session_params, param_key)

        %Plug.Conn{resp_body: resp_body} =
          post(conn, Routes.session_path(conn, :create), invalid_params)

        assert {:ok,
                %{
                  "error" =>
                    "missing required parameter. required params are username, password, client_id, and client_secret"
                }} = Jason.decode(resp_body)
      end
    end
  end

  defp setup_authentication_stub(context) do
    stub =
      Authentication
      |> stub(:get_app, fn _params ->
        if context[:get_app_result], do: context[:get_app_result], else: {:ok, build(:app)}
      end)
      |> stub(:verify_user, fn _params ->
        if context[:verify_user_result],
          do: context[:verify_user_result],
          else: {:ok, build(:user)}
      end)

    register(Authentication, stub)

    []
  end

  defp setup_session_stub(context) do
    stub =
      Session
      |> stub(:create_access_token, fn _app, _user ->
        if context[:create_access_token_result],
          do: context[:create_access_token_result],
          else: {:ok, @access_token}
      end)
      |> stub(:save_session, fn _app, _user, _token ->
        if context[:save_session_result],
          do: context[:save_session_result],
          else: {:ok, build(:session, token: @access_token)}
      end)
      |> stub(:clear_current_session, fn _app, _user ->
        if context[:clear_current_session_result],
          do: context[:clear_current_session_result],
          else: {:ok, build(:session)}
      end)

    register(Session, stub)

    []
  end
end
