defmodule WingmanFinder.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :encrypted_password, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end
