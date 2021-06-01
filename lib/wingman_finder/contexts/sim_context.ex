defmodule WingmanFinder.SimContext do
  alias WingmanFinder.{Repo, Sim}
  
  @spec list_sims() :: list(%Sim{})
  def list_sims, do: Repo.all(Sim)
  
  @spec get_sim(integer()) :: %Sim{}
  def get_sim(id), do: Repo.get(Sim, id)

  @spec create_sim(map()) :: {:ok, %Sim{}} | {:error, %Ecto.Changeset{}}
  def create_sim(attrs \\ %{}) do
    %Sim{}
    |> Sim.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_sim(%Sim{}, map()) :: {:ok, %Sim{}} | {:error, %Ecto.Changeset{}}
  def update_sim(%Sim{} = sim, attrs) do
    sim
    |> Sim.changeset(attrs)
    |> Repo.update()
  end
end
