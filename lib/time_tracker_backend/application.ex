defmodule TimeTrackerBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TimeTrackerBackend.Repo,
      # Start the Telemetry supervisor
      TimeTrackerBackendWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TimeTrackerBackend.PubSub},
      # Start the Endpoint (http/https)
      TimeTrackerBackendWeb.Endpoint,
      {Absinthe.Subscription, TimeTrackerBackendWeb.Endpoint},
      TimeTrackerBackend.Timer.ServicesSupervisor
      # Start a worker by calling: TimeTrackerBackend.Worker.start_link(arg)
      # {TimeTrackerBackend.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TimeTrackerBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TimeTrackerBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
