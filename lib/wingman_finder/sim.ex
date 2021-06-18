defmodule WingmanFinder.Sim do
  use WingmanFinder.Schema

  alias WingmanFinder.Module

  schema "sims" do
    field :name, :string

    has_many :modules, Module

    timestamps()
  end

  @doc false
  def changeset(sim, attrs) do
    sim
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
