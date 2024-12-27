import Config

config :storages, Storages.Repo,
  database: System.get_env("DB_NAME"),
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST")

config :web,
  port: System.get_env("WEB_PORT"),
  username: System.get_env("WEB_USERNAME"),
  password: System.get_env("WEB_PASSWORD")

config :bot,
  url: System.get_env("BOT_WS_URL")
