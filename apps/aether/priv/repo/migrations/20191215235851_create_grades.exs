defmodule Logic.Repo.Migrations.CreateGrades do
  use Ecto.Migration

  def change do
    create table(:grades) do
      add :name, :string
      add :earned, :integer
      add :possible, :integer

      timestamps()
    end

    create unique_index(:grades, [:name])
  end
end
