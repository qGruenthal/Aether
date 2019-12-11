defmodule AetherWeb.PageController do
  use AetherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def landing(conn, _params) do
    render(conn, "landing.html", %{courses: ["Stuff 101", "Stuff 200"]})
  end
end
