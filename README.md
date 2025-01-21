# AntiTracking

AntiTracking is a proof-of-concept project for a chatbot written in elixir.

The project is an umbrella one, consist of three apps:
- `:bot`
- `:storages`
- `:web`

Please refer to each apps in the `apps/` directory for more informations.

## Quickstart

Require elixir version >= 1.16

``` sh
# download dependencies
$ mix deps.get

# run and attach development servers
$ iex -S mix
```

## Releases

This project has a single release:
- `bot`: Complete application including bot client, webserver, and database interface

``` sh
$ MIX_ENV=prod mix compile
$ MIX_ENV=prod mix release
```

Please note that you need to supply required environment variables for compiling. See `.env.example` for variable list.
