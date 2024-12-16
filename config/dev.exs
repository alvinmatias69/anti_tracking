import Config

config :storages, Storages.Repo,
  database: "storages_repo",
  username: "storage_user",
  password: "qwe123123",
  hostname: "localhost"

config :web,
  port: 8080,
  username: "test",
  password: "test"
