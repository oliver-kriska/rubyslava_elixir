defmodule RubyslavaElixirWeb.PageController do
  use RubyslavaElixirWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
