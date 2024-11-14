defmodule Storages.Repo do
  use Ecto.Repo,
    otp_app: :storages,
    adapter: Ecto.Adapters.Postgres
end
