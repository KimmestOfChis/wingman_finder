defmodule WingmanFinder.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: WingmanFinder.Repo

  def sim_factory do
    %WingmanFinder.Sim{
      name: sequence(:name, &"sim-#{&1}")
    }
  end

  def module_factory do
    %WingmanFinder.Module{
      name: sequence(:name, &"module-#{&1}"),
      type: "map",
      sim: build(:sim)
    }
  end

  def user_factory do
    %WingmanFinder.User{
      username: Faker.Pokemon.name(),
      email: Faker.Internet.email(),
      password: Faker.Lorem.characters() |> List.to_string()
    }
  end

  def app_factory do
    %WingmanFinder.App{
      display_name: Faker.Pokemon.name(),
      api_key: Faker.UUID.v4(),
      api_secret: Faker.UUID.v4()
    }
  end
end
