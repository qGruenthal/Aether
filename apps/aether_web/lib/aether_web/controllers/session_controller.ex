defmodule AetherWeb.SessionController do
  use AetherWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"name" => name, "password" => pass}}) do
    case AetherWeb.Auth.check_login(conn, name, pass) do
      {:ok, conn} ->
	conn
	|> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason, conn} ->
	conn
	|> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> AetherWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

