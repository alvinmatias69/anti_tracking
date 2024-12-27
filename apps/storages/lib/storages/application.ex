defmodule Storages.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Storages.Repo,
      {Storages.Cache, name: Storages.Cache}
    ]

    opts = [strategy: :one_for_one, name: Storages.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
