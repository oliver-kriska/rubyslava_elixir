defmodule RubyslavaElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RubyslavaElixirWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RubyslavaElixir.PubSub},
      # Start the Endpoint (http/https)
      RubyslavaElixirWeb.Endpoint,
      {RubyslavaElixir.Questions, []}
      # Start a worker by calling: RubyslavaElixir.Worker.start_link(arg)
      # {RubyslavaElixir.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RubyslavaElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RubyslavaElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
