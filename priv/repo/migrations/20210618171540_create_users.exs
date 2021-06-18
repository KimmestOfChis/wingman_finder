defmodule WingmanFinder.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password_hashed, :string, null: false

      timestamps()
    end
  end
end
