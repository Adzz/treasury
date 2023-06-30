defmodule Treasury.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TreasuryWeb.Telemetry,
      # Start the Ecto repository
      Treasury.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Treasury.PubSub},
      # Start Finch
      {Finch, name: Treasury.Finch},
      # Start the Endpoint (http/https)
      TreasuryWeb.Endpoint
      # Start a worker by calling: Treasury.Worker.start_link(arg)
      # {Treasury.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Treasury.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TreasuryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
