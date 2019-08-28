defmodule AetherWeb.GerasController do
  use AetherWeb, :controller

  import Exexec

  def grades(conn, _params) do
    render(conn, "grades.html", tests: "grade")
  end

  def example(conn, _params) do
    json(conn, %{tests: [
                    %{name: "t1", passed: true, value: 1},
                    %{name: "t2", passed: true, value: 2},
                    %{name: "t3", passed: false, value: 3}
                  ]})
  end

  def grade(conn, _params) do
    command = "tmp=$(echo \"$(mktemp)\"); momus > $tmp; cat $tmp; rm $tmp"
    {:ok, pid, os_pid} = run_link(command,
      cd: "apps/aether_web/assets/static/examples",
      stdout: true)

    critique = receive do
      {:stdout, ^os_pid, output} ->
        output
    end

    case Jason.decode(critique) do
      {:ok, critique} ->
        json(conn, critique)
      {:error, _} ->
        json(conn, %{error: "Failed to Parse Critique."})
    end
  end
end
