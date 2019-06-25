defmodule Calculator.Application do
  use Application

  def start(_type, _args) do
    Calculator.Metrics.setup()

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Calculator.Router,
        options: [port: 4001]
      ),
      Calculator.InfluxDB
    ]

    opts = [strategy: :one_for_one, name: Calculator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
