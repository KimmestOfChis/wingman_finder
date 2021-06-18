defmodule WingmanFinder.Module do
  use WingmanFinder.Schema

  alias WingmanFinder.Sim

  schema "modules" do
    field :name, :string
    field :type, :string

    belongs_to :sim, Sim

    timestamps()
  end

  @doc false
  def changeset(module, attrs) do
    module
    |> cast(attrs, [:name, :type, :sim_id])
    |> validate_required([:name, :type, :sim_id])
    |> unique_constraint(:name)
  end
end
