import Config

config :storages, Storages.Repo,
  username: "test_user",
  password: "test_pass",
  database: "test_db",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :web,
  port: 8080,
  username: "test",
  password: "test"
