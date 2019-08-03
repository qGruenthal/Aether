defmodule AetherWeb.GerasController do
  use AetherWeb, :controller
  
  def grades(conn, _params) do
    render(conn, "grades.html")
  end
end
