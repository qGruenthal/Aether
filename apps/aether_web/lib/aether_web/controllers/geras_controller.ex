defmodule AetherWeb.GerasController do
  use AetherWeb, :controller

  alias Aether.Momus.Runner

  @upload_dir Application.get_env(:aether, :uploads_dir)

  def grades(conn, _params) do
    render(conn, "grades.html", %{type: "tests", url: "grade"})
  end

  def assignments(conn, _params) do
    render(conn, "grades.html", %{type: "grades", url: "assignment"})
  end

  def example(conn, _params) do
    json(conn, %{tests: [
                    %{name: "t1", passed: true, value: 1},
                    %{name: "t2", passed: true, value: 2},
                    %{name: "t3", passed: false, value: 3}
                  ]})
  end

  def assignment(conn, _params) do
    json(conn, %{grades: [
                    %{name: "t1", earned: 10, possible: 10},
                    %{name: "t2", earned: 9, possible: 10},
                    %{name: "t3", earned: 5, possible: 10}
                  ]})
  end

  def grade(conn, _params) do

    #critique = Jason.encode!(%{tests: [%{name: "t1", passed: true, value: 1}, %{name: "t2", passed: true, value: 2}, %{name: "t3", passed: false, value: 3}]})

    task = Task.async(fn -> Runner.run_momus end)

    critique =
      case Task.yield(task, 15000) || Task.shutdown(task) do
        {:ok, result} ->
          result

        _ ->
          nil
      end

    case Jason.decode(critique) do
      {:ok, d_critique} ->
        json(conn, d_critique)
      {:error, _} ->
        json(conn, %{error: "Failed to Parse Critique."})
    end
  end
end
