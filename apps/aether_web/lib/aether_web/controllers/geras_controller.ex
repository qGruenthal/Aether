defmodule AetherWeb.GerasController do
  use AetherWeb, :controller

  alias Aether.Momus.Runner
  alias Aether.Repo
  alias Aether.Courses.Grade

  require Logger

  @upload_dir Application.get_env(:aether, :uploads_dir)

  def grades(conn, %{"course" => course, "assignment" => assignment}) do
    render(conn, "grades.html", %{type: "tests", url: "grade/#{assignment}", course: course, assignment: assignment, flag: true})
  end

  def assignments(conn, %{"course" => course}) do
    render(conn, "grades.html", %{type: "grades", url: course, course: course, flag: false, assignments: ["Demo"]})
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
                    %{name: "Intro", earned: 10, possible: 10},
                    %{name: "Basics", earned: 9, possible: 10},
                    %{name: "The Real Stuff", earned: 5, possible: 10}
                  ]})
  end

  def pool(conn, _params) do
    gs = for g <- Repo.all(Grade), do: %{name: g.name, earned: g.earned, possible: g.possible}
    json(conn, %{grades: gs})
  end

  def grade(conn, %{"name" => name}) do

    #critique = Jason.encode!(%{tests: [%{name: "t1", passed: true, value: 1}, %{name: "t2", passed: true, value: 2}, %{name: "t3", passed: false, value: 3}]})

    task = Task.async(fn -> Runner.run_momus end)

    critique =
      case Task.yield(task, 25000) || Task.shutdown(task) do
        {:ok, result} ->
          case Jason.decode(result) do
            {:ok, d_result} ->
              possible = for t <- d_result["tests"], do: t["value"]
              earned = for t <- d_result["tests"], do: if t["passed"], do: t["value"], else: 0
              Repo.insert!(%Grade{name: name, earned: Enum.sum(earned), possible: Enum.sum(possible)},
                on_conflict: :replace_all,
                conflict_target: :name
              )
            {:error, _} ->
              result = json(conn, %{tests: [%{name: "TIMEOUT", passed: false, value: 1}]})
          end
          result
        _ ->
          json(conn, %{tests: [%{name: "TIMEOUT", passed: false, value: 1}]})
      end

    case Jason.decode(critique) do
      {:ok, d_critique} ->
        Logger.warn "#{inspect(d_critique)}"
        json(conn, d_critique)
      {:error, _} ->
        json(conn, %{error: "Failed to Parse Critique."})
    end
  end
end
