defmodule Aether.Momus.Runner do
  import Exexec

  require Logger

  @upload_dir Application.get_env(:aether, :uploads_dir)

  def run_momus do

    Logger.debug "ant"

    #command = "tmp=$(echo \"$(mktemp)\"); sleep 1; momus > $tmp; cat $tmp; rm $tmp"
    command = "tmp=$(echo \"$(mktemp)\"); docker run --rm --mount type=bind,source=/home/quin/uploads/1,target=/momus -w /momus momus momus > $tmp; cat $tmp; rm $tmp"
    {:ok, pid, os_pid} = run_link(command,
      #cd: Path.join([@upload_dir, "1"]),
      stdout: true)

    critique = receive do
      {:stdout, ^os_pid, output} ->
        output
    end

    Logger.debug "#{inspect(critique)}"

    #Jason.encode!(%{tests: [%{name: "t1", passed: true, value: 1}, %{name: "t2", passed: true, value: 2}, %{name: "t3", passed: false, value: 3}]})
    critique
  end

end
