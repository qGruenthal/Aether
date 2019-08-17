defmodule AetherWeb.GerasController do
  use AetherWeb, :controller

  import Exexec

  def grades(conn, _params) do
    render(conn, "grades.html", tests: "example")
  end

  def example(conn, _params) do
    json(conn, %{tests: [
                    %{name: "t1", passed: true, value: 1},
                    %{name: "t2", passed: true, value: 2},
                    %{name: "t3", passed: false, value: 3}
                  ]})
  end

  def grade(conn, _params) do
    command = "cd apps/aether_web/assets/static/examples && momus"
    {:ok, pid, os_pid} = run_link(command, stdout: true)
    #result = Enum.at(out[:stdout], 0)
    #IO.puts(result)
    #IO.puts(out[:stdout])
    critique = receive do
      {:stdout, ^os_pid, output} ->
        "{\"tests\": [\n" <> output <> "]}\n"
    end

    #IO.puts(critique)
    ant = """
{\"tests\": [
  {\"name\": \"t01\", \"passed\": true, \"value\": 1},
  {\"name\": \"t02\", \"passed\": true, \"value\": 1},
  {\"name\": \"t03\", \"passed\": true, \"value\": 1},
  {\"name\": \"t04\", \"passed\": true, \"value\": 1},
  {\"name\": \"t05\", \"passed\": true, \"value\": 1},
  {\"name\": \"t06\", \"passed\": true, \"value\": 1},
  {\"name\": \"t07\", \"passed\": true, \"value\": 1},
  {\"name\": \"t08\", \"passed\": true, \"value\": 1},
  {\"name\": \"t09\", \"passed\": true, \"value\": 1},
  {\"name\": \"t10\", \"passed\": true, \"value\": 1},
  {\"name\": \"t11\", \"passed\": true, \"value\": 1},
  {\"name\": \"t12\", \"passed\": true, \"value\": 1},
  {\"name\": \"t13\", \"passed\": true, \"value\": 1},
  {\"name\": \"t14\", \"passed\": true, \"value\": 1},
  {\"name\": \"t15\", \"passed\": true, \"value\": 1}
]}
"""
    case Jason.decode(ant) do
      {:ok, critique} ->
        json(conn, critique)
      {:error, _} ->
        json(conn, %{error: "Failed to Parse Critique."})
    end
  end
end
