defmodule Calculator do
  use Tesla
  import Opencensus.Trace

  require Logger

  plug(Tesla.Middleware.JSON)
  plug(OpencensusTesla.Middleware)

  adapter(Tesla.Adapter.Hackney, recv_timeout: 30_000)

  def calculate(operation, n1, n2) do
    int1 = String.to_integer(n1)
    int2 = String.to_integer(n2)

    with_child_span "traced" do
      send_calculation(operation, int1, int2)
    end
  rescue
    ArgumentError ->
      response =
        Jason.encode!(%{
          status: :failed,
          message: "Numbers aren't all integers",
          operation: operation,
          n1: n1,
          n2: n2
        })

      Logger.error(fn -> response end)

      {400, response}
  end

  defp send_calculation(service_host, n1, n2) do
    "http://#{service_host}/exec?n1=#{n1}&n2=#{n2}"
    |> get()
    |> parse_response(service_host, n1, n2)
  end

  defp parse_response({:ok, response}, _, _, _) do
    handle_success(response)
  end

  defp parse_response({:error, _}, service_host, n1, n2) do
    Logger.error(fn ->
      Jason.encode!(%{
        status: :failed,
        message: "Could not get a successful response",
        operation: service_host,
        n1: n1,
        n2: n2
      })
    end)

    {500,
     Jason.encode!(%{
       status: :failed,
       message: "Could not get a successful response"
     })}
  end

  defp handle_success(%{status: 200, body: body}) do
    {200, body}
  end

  defp handle_success(%{status: 404}) do
    {404,
     Jason.encode!(%{
       status: :failed,
       message: "404",
       http_code: 404
     })}
  end

  defp handle_success(%{status: 500}) do
    {500,
     Jason.encode!(%{
       status: :failed,
       message: "500",
       http_code: 500
     })}
  end

  defp handle_success(response) do
    {500,
     Jason.encode!(%{
       status: :failed,
       message: "Help",
       debug: response
     })}
  end
end
