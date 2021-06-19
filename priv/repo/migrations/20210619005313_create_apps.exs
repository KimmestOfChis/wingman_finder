defmodule WingmanFinder.Repo.Migrations.CreateApps do
  use Ecto.Migration

  def change do
    create table(:apps) do
      add :api_key, :string, null: false
      add :api_secret, :string, null: false
      add :display_name, :string, null: false

      timestamps()
    end
  end
end
