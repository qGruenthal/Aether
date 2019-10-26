defmodule Aether.Moros.Assignments do
  import Ecto.Query, warn: false

  alias Aether.Repo
  alias Aether.Moros.Assignments.Upload

  def create_upload(%Plug.Upload{filename: filename, path: tmp_path, content_type: content_type}) do
    hash =
      File.stream!(tmp_path, [], 2048)
      |> Upload.hash()

    Repo.transaction fn ->
      with {:ok, %File.Stat{size: size}} <- File.stat(tmp_path),
           {:ok, upload} <-
             %Upload{}
             |> Upload.changeset(%{filename: filename, hash: hash, size: size })
             |> Repo.insert(),
           :ok <-
             File.cp(tmp_path, Upload.file_path(filename))
      do
        {:ok, upload}
      else
        {:error, reason} ->
          IO.puts reason
          Repo.rollback(reason)
      end
    end
  end
end
