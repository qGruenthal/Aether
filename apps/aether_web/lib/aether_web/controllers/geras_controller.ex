defmodule AetherWeb.GerasController do
  use AetherWeb, :controller
  
  def grades(conn, _params) do
    render(conn, "grades.html", tests: "example")
  end

  def example(conn, _params) do
    json(conn, %{tests: [%{name: "t1", passed: true, value: 1}, %{name: "t2", passed: true, value: 2}, %{name: "t3", passed: false, value: 3}]})
  end
end
