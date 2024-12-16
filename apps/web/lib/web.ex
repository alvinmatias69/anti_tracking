defmodule Web do
  use Plug.Router

  plug(:match)
  plug(Plug.Logger)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  forward("/tracker", to: Web.TrackerRouter)

  match _ do
    send_resp(conn, 404, "not found")
  end
end
