defmodule WingmanFinderWeb.Plug.ApiAuthenticatedTest do
  use WingmanFinderWeb.ConnCase

  describe "init/1" do
    test "it returns the opts passed", %{conn: _conn} do
      assert false
    end
  end

  describe "call/2" do
    test "validates the an app/user pair based on the authorization header", %{conn: _conn} do
      assert false
    end

    test "it gets an invalid authorization header", %{conn: _conn} do
      assert false
    end

    test "the call to Session.validate_access_token fails", %{conn: _conn} do
      assert false
    end

    test "the call to Authentication.get_app fails", %{conn: _conn} do
      assert false
    end

    test "the call to Authentication.get_user fails", %{conn: _conn} do
      assert false
    end
  end
end
