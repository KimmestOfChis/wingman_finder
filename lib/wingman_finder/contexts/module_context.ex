defmodule WingmanFinder.ModuleContext do
  alias WingmanFinder.{Repo, Module}

  @spec list_modules() :: list(%Module{})
  def list_modules, do: Repo.all(Module)

  @spec get_module(integer()) :: %Module{}
  def get_module(id), do: Repo.get(Module, id)

  @spec create_module(map()) :: {:ok, %Module{}} | {:error, %Ecto.Changeset{}}
  def create_module(attrs \\ %{}) do
    %Module{}
    |> Module.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_module(%Module{}, map()) :: {:ok, %Module{}} | {:error, %Ecto.Changeset{}}
  def update_module(%Module{} = module, attrs) do
    module
    |> Module.changeset(attrs)
    |> Repo.update()
  end
end
