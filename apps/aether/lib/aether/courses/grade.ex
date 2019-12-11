defmodule Aether.Courses.Grade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "grades" do
    field :name, :string
    field :earned, :integer
    field :possible, :integer

    timestamps()
  end

  @doc false
  def changeset(grade, attrs) do
    grade
    |> cast(attrs, [:name, :earned, :possible])
    |> unique_constraint(:name)
  end
end
