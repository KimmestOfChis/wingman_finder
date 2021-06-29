defmodule WingmanFinder.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :token, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :app_id, references(:apps, on_delete: :nothing)

      timestamps()
    end

    create index(:sessions, [:user_id])
    create index(:sessions, [:app_id])
  end
end
