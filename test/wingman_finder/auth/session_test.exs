defmodule WingmanFinder.Auth.SessionTest do
  use WingmanFinder.DataCase

  import Double, only: [stub: 3]
  import Inject, only: [register: 2]

  import WingmanFinder.Factory

  alias WingmanFinder.Auth.Session

  # one day
  @token_max_age 86400
  @token_namespace "user auth"
  @token_salt "spicy"

  @token "dude-coin"

  describe "create_access_token/2" do
    setup [:setup_application_stub, :setup_phoenix_token_stub]

    setup do
      [app: insert(:app), user: insert(:user)]
    end

    test "it wraps Phoenix.Token.sign/3", %{
      app: %{id: expected_app_id} = app,
      user: %{id: expected_user_id} = user
    } do
      assert @token = Session.create_access_token(app, user)

      assert_receive {Phoenix.Token, :sign,
                      [
                        @token_salt,
                        @token_namespace,
                        %{app_id: ^expected_app_id, user_id: ^expected_user_id}
                      ]}
    end
  end

  describe "validate_access_token/1" do
    setup [:setup_application_stub, :setup_phoenix_token_stub]

    setup do
      [app: insert(:app), user: insert(:user)]
    end

    test "it validates the token and fetches the data within the session" do
      assert false
    end

    test "Phoenix.Token.verify/4 fails" do
      assert false
    end

    test "the session does not exist in the database" do
      assert false
    end
  end

  describe "clear_current_session/3" do
    test "if a session matches, we delete it" do
      assert false
    end

    test "if a session does not match, we do nothing" do
      assert false
    end
  end

  describe "delete_session/1" do
    test "wraps Repo.delete/1" do
      assert false
    end

    test "deals with nil input gracefully" do
      assert false
    end
  end

  describe "get_session/2" do
    test "wraps Repo.get_by/2" do
      assert false
    end
  end

  describe "save_session/3" do
    test "validates the input and saves the session, basically wraps Repo.insert/1" do
      assert false
    end

    test "returns an error if changeset validation fails" do
      assert false
    end

    test "returns an error if inserting fails" do
      assert false
    end
  end

  defp setup_phoenix_token_stub(_context) do
    stub = stub(Phoenix.Token, :sign, fn _salt, _namespace, _data -> @token end)
    register(Phoenix.Token, stub)
    []
  end

  defp setup_application_stub(_context) do
    stub =
      stub(Application, :fetch_env!, fn :wingman_finder, :token_signing_salt -> @token_salt end)

    register(Application, stub)
    []
  end
end
