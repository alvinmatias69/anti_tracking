defmodule Bot.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Bot.TaskSupervisor},
      {Bot, [async: true, name: Bot, url: Application.fetch_env!(:bot, :url)]}
    ]

    opts = [strategy: :one_for_one, name: Bot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
