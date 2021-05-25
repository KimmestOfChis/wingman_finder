defmodule WingmanFinder.Repo.Migrations.AddModulesTable do
  use Ecto.Migration

  def change do
    create table(:modules) do
      add :name, :string, null: false
      add :sim_id, references(:sims)

      timestamps
    end

    create unique_index(:modules, [:name])
  end
end
