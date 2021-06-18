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
end
