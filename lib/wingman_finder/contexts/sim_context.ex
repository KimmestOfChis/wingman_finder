defmodule WingmanFinder.SimContext do
  alias WingmanFinder.{Repo, Sim}

  def list_sims do
    Repo.all(Sim)
  end

  def get_sim(id), do: Repo.get(Sim, id)

  def create_sim(attrs \\ %{}) do
    %Sim{}
    |> Sim.changeset(attrs)
    |> Repo.insert()
  end

  def update_sim(%Sim{} = sim, attrs) do
    sim
    |> Sim.changeset(attrs)
    |> Repo.update()
  end
end
