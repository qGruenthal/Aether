defmodule Aether.Momus.Runner do
  import Exexec

  require Logger

  @upload_dir Application.get_env(:aether, :uploads_dir)

  def run_momus do

    Logger.debug "ant"

    command = "tmp=$(echo \"$(mktemp)\"); docker run -it --rm --mount type=bind,source=/home/quin/,target=/momus -w /momus -e \"GUILE_AUTO_COMPILE=0\" momus momus > $tmp; cat $tmp; rm $tmp"
    {:ok, pid, os_pid} = run_link(command,
      cd: Path.join([@upload_dir, "examples"]),
      stdout: true)

    Logger.debug "ant"

    critique = receive do
      {:stdout, ^os_pid, output} ->
        output
    end

    Jason.encode!(%{tests: [%{name: "t1", passed: true, value: 1}, %{name: "t2", passed: true, value: 2}, %{name: "t3", passed: false, value: 3}]})
  end

end
