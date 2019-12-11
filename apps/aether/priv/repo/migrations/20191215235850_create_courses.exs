defmodule Logic.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :assignments, {:array, :string}

      timestamps()
    end

    create unique_index(:courses, [:name])
  end
end
