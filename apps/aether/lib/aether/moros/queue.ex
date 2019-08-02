defmodule Aether.Moros.Queue do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, ["Ant", "Fish", "Cabbage"], name: __MODULE__)
  end

  def push(new_item) do
    GenServer.cast(__MODULE__, {:push, new_item})
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, new_item}, state) do
    {:noreply, state ++ [new_item]}
  end
end
