defmodule RubyslavaElixirWeb.BoardPresence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :rubyslava_elixir,
    pubsub_server: RubyslavaElixir.PubSub
end
