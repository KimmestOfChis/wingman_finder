defmodule WingmanFinder.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: WingmanFinder.Repo

  alias WingmanFinder.Auth.{Authentication, Session}

  def app_factory do
    %WingmanFinder.App{
      display_name: Faker.Pokemon.name(),
      api_key: Faker.UUID.v4(),
      api_secret: Faker.UUID.v4()
    }
  end

  def module_factory do
    %WingmanFinder.Module{
      name: sequence(:name, &"module-#{&1}"),
      type: "map",
      sim: build(:sim)
    }
  end

  def session_factory(attrs) do
    user = if attrs[:user], do: attrs[:user], else: build(:user)
    app = if attrs[:app], do: attrs[:app], else: build(:app)
    token = if attrs[:token], do: attrs[:token], else: Session.create_access_token(user, app)

    %WingmanFinder.Session{
      app: app,
      token: token,
      user: user
    }
  end

  def sim_factory do
    %WingmanFinder.Sim{
      name: sequence(:name, &"sim-#{&1}")
    }
  end

  def user_factory do
    user_opts =
      %{
        username: Faker.Pokemon.name(),
        email: Faker.Internet.email(),
        password: Faker.Lorem.characters() |> List.to_string()
      }
      |> with_password_hash()

    Map.merge(%WingmanFinder.User{}, user_opts)
  end

  defp with_password_hash(%{password: password} = user),
    do: Map.merge(user, Authentication.hash_password(password))
end
