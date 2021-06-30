defmodule WingmanFinderWeb.SessionControllerTest do
  use WingmanFinderWeb.ConnCase

  import Double, only: [stub: 3]
  import Inject, only: [register: 2]

  import WingmanFinder.Factory

  alias WingmanFinder.Authentication

  @access_token "token"

  @session_params %{
    "username" => "username",
    "password" => "password",
    "client_id" => "client_id",
    "client_secret" => "client_secret"
  }

  describe "/login" do
    setup [:setup_authentication_stub]

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
      |> stub(:create_access_token, fn _app, _user ->
        if context[:create_access_token_result],
          do: context[:create_access_token_result],
          else: {:ok, @access_token}
      end)

    register(Authentication, stub)

    []
  end
end