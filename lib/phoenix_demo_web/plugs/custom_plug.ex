defmodule CustomPlug do
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    Appsignal.Span.set_sample_data(
      Appsignal.Tracer.root_span(),
      "custom_data",
      %{
        current_user_id: 1234,
        distribution_id: 444,
        request_path: "/auth/auth0/callback",
        workspace_id: ""
      }
    )
    conn
  end
end
