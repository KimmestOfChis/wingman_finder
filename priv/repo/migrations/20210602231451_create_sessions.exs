defmodule WingmanFinder.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :user_id, references(:users), nil: false
      add :jwt, :string, nil: false
      add :expires_at, :utc_datetime_usec

      timestamps(type: :utc_datetime_usec)
    end
  end
end
