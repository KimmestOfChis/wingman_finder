defmodule WingmanFinder.Auth.AuthenticationTest do
  use WingmanFinder.DataCase

  import Double, only: [stub: 3]
  import Inject, only: [register: 2]

  import WingmanFinder.Factory

  alias WingmanFinder.Auth.Authentication
  alias WingmanFinder.{App, Repo, User}

  @get_by_opts [my: :opts]

  @password "keep_it_secret"
  @password_hash "cornbeef"

  describe "get_app/1" do
    setup [:setup_repo_stub]

    test "it wraps Repo.get_by/2 and returns an App" do
      assert %App{} = Authentication.get_app(@get_by_opts)

      assert_receive {Repo, :get_by, [App, @get_by_opts]}
    end
  end

  describe "get_user/1" do
    setup [:setup_repo_stub]

    test "it wraps Repo.get_by/2 and returns a User" do
      assert %User{} = Authentication.get_user(@get_by_opts)

      assert_receive {Repo, :get_by, [User, @get_by_opts]}
    end
  end

  describe "verify_user/2" do
    setup [:setup_bcrypt_stub]

    setup do
      [user: insert(:user)]
    end

    test "it fetches the user and verifies the password via Bcrypt", %{
      user:
        %{
          id: expected_user_id,
          password_hash: expected_password_hash,
          password: expected_password
        } = user
    } do
      assert {:ok, %User{id: ^expected_user_id}} =
               Authentication.verify_user(user.username, user.password)

      assert_receive {Bcrypt, :check_pass,
                      [
                        %User{id: actual_user_id, password_hash: actual_password_hash},
                        ^expected_password
                      ]}

      assert expected_user_id == actual_user_id
      assert expected_password_hash == actual_password_hash
    end

    test "User does not exist", %{user: %{password: expected_password} = user} do
      Repo.delete!(User, user)

      assert {:error, "blew up"} = Authentication.verify_user(user.username, user.password)

      assert_receive {Bcrypt, :check_pass, [nil, ^expected_password]}
    end

    @tag check_pass_result: {:error, "blew up"}
    test "Bcrypt fails password check", %{
      user: %{id: user_id, password: expected_password} = user
    } do
      assert {:error, "blew up"} = Authentication.verify_user(user.username, user.password)

      assert_receive {Bcrypt, :check_pass,
                      [
                        %User{id: ^user_id},
                        ^expected_password
                      ]}
    end
  end

  describe "hash_password/1" do
    setup [:setup_bcrypt_stub]

    test "calls Bcrypt to hash the password" do
      assert %{password_hash: @password_hash} = Authentication.hash_password(@password)
      assert_receive {Bcrypt, :add_hash, [@password]}
    end
  end

  defp setup_bcrypt_stub(context) do
    stub =
      Bcrypt
      |> stub(:add_hash, fn _password -> %{password_hash: @password_hash} end)
      |> stub(:check_pass, fn struct, _password ->
        if context[:check_pass_result], do: context[:check_pass_result], else: {:ok, struct}
      end)

    register(Bcrypt, stub)
    []
  end

  defp setup_repo_stub(_context) do
    stub =
      Repo
      |> stub(:get_by, fn App, _opts -> insert(:app) end)
      |> stub(:get_by, fn User, _opts -> insert(:user) end)

    register(Repo, stub)
    []
  end
end
