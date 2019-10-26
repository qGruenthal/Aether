defmodule Aether.Moros.Builder do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    check_queue()

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    #IO.puts("Doing Work...")
    {:ok}
    do_work(Aether.Moros.Queue.pop)
    check_queue()

    {:noreply, state}
  end

  defp do_work(item) when item == nil do
    #IO.puts("Finished\n")
  end

  defp do_work(item) do
    #IO.puts(item)
    :timer.sleep(1000)
    do_work(Aether.Moros.Queue.pop)
  end

  defp check_queue do
    Process.send_after(self(), :work, 5_000)
  end
end
