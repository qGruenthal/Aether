defmodule AetherWeb.UserController do
  use AetherWeb, :controller

  alias Aether.Accounts
  alias Aether.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> AetherWeb.Auth.login(user)
        |> redirect(to: Routes.page_path(conn, :landing))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
