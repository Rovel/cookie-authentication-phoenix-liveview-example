defmodule Shop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Shop.Repo,
      # Start the Telemetry supervisor
      ShopWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Shop.PubSub},
      # Start the Endpoint (http/https)
      ShopWeb.Endpoint
      # Start a worker by calling: Shop.Worker.start_link(arg)
      # {Shop.Worker, arg}
    ]

    :ets.new(:shop_auth_table, [:set, :public, :named_table, read_concurrency: true])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ShopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
