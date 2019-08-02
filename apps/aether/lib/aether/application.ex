defmodule Aether.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Aether.Repo,
      Aether.Moros.Builder,
      Aether.Moros.Queue
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Aether.Supervisor)
  end
end
