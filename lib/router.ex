defmodule Calculator.Router do
  use Plug.Router
  require Logger

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(Calculator.Metrics)
  plug(Calculator.InfluxDB.ResponseTimes)
  plug(Plug.RequestId)
  plug(Calculator.Traces)
  plug(:dispatch)

  get "/ping" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{message: "pong"}))
  end

  get "/calculate" do
    operator = conn.query_params["operator"]

    int1 = conn.query_params["n1"]
    int2 = conn.query_params["n2"]

    if is_nil(operator) or is_nil(int1) or is_nil(int2) do
      Logger.error(fn ->
        Jason.encode!(%{message: "Missing Parameter", operator: operator, n1: int1, n2: int2})
      end)

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(500, Jason.encode!(%{message: "Missing Value"}))
    else
      {status, response} = Calculator.calculate(operator, int1, int2)

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(status, response)
    end
  end

  match _ do
    # Logger.error(fn -> %{message: "Unknown Route", route: unknown_route} end)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      404,
      Jason.encode!(%{
        message: "Unknown Route"
      })
    )
  end
end
