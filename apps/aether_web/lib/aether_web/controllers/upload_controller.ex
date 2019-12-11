defmodule AetherWeb.UploadController do
  use AetherWeb, :controller

  alias Aether.Moros.Assignments

  require Logger

  def new(conn, %{"name" => name}) do
    render(conn, "new.html")
  end

  def create(conn, %{"upload" => %Plug.Upload{}=upload}) do
    Logger.warn "ant #{inspect(conn.assigns.current_user.id)}"
    case Assignments.create_upload(upload, conn.assigns.current_user.id) do
      {:ok, upload} ->
        redirect(conn, to: Routes.geras_path(conn, :grades, "Stuff 200",  "Demo"))
      {:error, reason} ->
        render(conn, "new.html")
    end
  end

  def create(conn, _) do
    render(conn, "new.html")
  end
end
