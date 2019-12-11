defmodule Aether.Moros.Assignments.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uploads" do
    field :filename, :string
    field :hash, :string
    field :size, :integer

    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, [:filename, :size, :hash])
    |> validate_required([:filename, :size, :hash])
    |> validate_number(:size, greater_than: 0)
    |> validate_length(:hash, is: 64)
  end

  def hash(chunks) do
    chunks
    |> Enum.reduce(
      :crypto.hash_init(:sha256),
      &(:crypto.hash_update(&2, &1))
    )
    |> :crypto.hash_final()
    |> Base.encode16()
    |> String.downcase()
  end

  def upload_dir do
    Application.get_env(:aether, :uploads_dir)
  end

  def file_path(user_path, filename) do
    [upload_dir(), "#{user_path}", "#{filename}"]
    |> Path.join()
  end
end
