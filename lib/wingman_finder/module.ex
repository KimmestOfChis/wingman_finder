defmodule WingmanFinder.Module do
  use Ecto.Schema
  import Ecto.Changeset

  alias WingmanFinder.Sim

  schema "modules" do
    field :name, :string

    belongs_to :sim, Sim

    timestamps()
  end

  def changeset(module, attrs) do
    module
    |> cast(attrs, [:name, :sim_id])
    |> validate_required([:name, :sim_id])
    |> unique_constraint(:name)
  end
end
