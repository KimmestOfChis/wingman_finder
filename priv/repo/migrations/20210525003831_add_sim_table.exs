defmodule WingmanFinder.Repo.Migrations.AddSimTable do
  use Ecto.Migration

  def change do
    create table(:sims) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:sims, [:name])
  end
end
