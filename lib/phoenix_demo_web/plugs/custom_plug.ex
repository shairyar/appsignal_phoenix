defmodule CustomPlug do
  use Plug.Router
  use Appsignal.Plug # <- Add this

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome")
  end
end
