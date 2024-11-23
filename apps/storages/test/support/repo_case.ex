defmodule Storages.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Storages.Repo

      import Ecto
      import Ecto.Query
      import Storages.RepoCase
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Storages.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end
end
