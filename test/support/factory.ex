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
      sim: build(:sim)
    }
  end
end
