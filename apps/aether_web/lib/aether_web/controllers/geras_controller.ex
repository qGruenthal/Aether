defmodule AetherWeb.GerasController do
  use AetherWeb, :controller

  require Logger

  #import Exexec
  alias RemoteDockers.NodeConfig
  alias RemoteDockers.Container
  alias RemoteDockers.ContainerConfig

  alias RemoteDockers.Image

  @upload_dir Application.get_env(:aether, :uploads_dir)

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

  def run_momus do
    node = NodeConfig.new("127.0.0.1", 2375)
    container_config =
      ContainerConfig.new("momus:latest")
      |> ContainerConfig.add_env("GUILE_AUTO_COMPILE", "0")
      |> ContainerConfig.add_mount_point("/home/quin/uploads/examples", "/momus")

    try do
      container = Container.create!(node, "momus_instance", container_config)
      Logger.debug "this: #{inspect(container)}"
    rescue
      e -> Logger.debug "#{inspect(e)}"
    end

    Logger.debug "containers: #{inspect(Container.remove!(Enum.at Container.list_all!(node), 0))}"

    Jason.encode!(%{tests: [%{name: "t1", passed: true, value: 1}, %{name: "t2", passed: true, value: 2}, %{name: "t3", passed: false, value: 3}]})
  end

  def grade(conn, _params) do

    #critique = Jason.encode!(%{tests: [%{name: "t1", passed: true, value: 1}, %{name: "t2", passed: true, value: 2}, %{name: "t3", passed: false, value: 3}]})

    task = Task.async(fn -> run_momus end)

    critique =
      case Task.yield(task, 5000) || Task.shutdown(task) do
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
