defmodule AetherWeb.UploadController do
  use AetherWeb, :controller

  alias Aether.Moros.Assignments

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
    case Assignments.create_upload(upload) do
      {:ok, upload} ->
        redirect(conn, to: Routes.page_path(conn, :index))
      {:error, reason} ->
        render(conn, "new.html")
    end
  end
end
