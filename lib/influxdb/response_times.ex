defmodule Calculator.InfluxDB.ResponseTimes do
  use Instream.Series
  require Logger

  series do
    measurement("routes")

    tag(:http_type)
    tag(:status)
    tag(:path)

    field(:response_time)
    field(:n1)
    field(:n2)
  end

  def init(options), do: options

  def call(conn, _) do
    start = :os.system_time(:nano_seconds)

    int1 = String.to_integer(conn.query_params["n1"])
    int2 = String.to_integer(conn.query_params["n2"])

    Logger.debug(fn -> "Start Time for Request is #{start}" end)

    Plug.Conn.register_before_send(conn, fn conn ->
      stop = :os.system_time(:nano_seconds)

      Logger.debug(fn -> "Stop Time for Request is #{stop}" end)

      data = %__MODULE__{}

      data = %{
        data
        | tags: %{
            data.tags
            | http_type: conn.method,
              status: conn.status,
              path: conn.request_path
          },
          fields: %{
            data.fields
            | response_time: stop - start
          }
      }

      data =
        if Map.has_key?(conn.query_params, "n1") do
          %{data | fields: %{data.fields | n1: int1}}
        else
          data
        end

      data =
        if Map.has_key?(conn.query_params, "n2") do
          %{data | fields: %{data.fields | n2: int2}}
        else
          data
        end

      Calculator.InfluxDB.write(data)

      conn
    end)
  rescue
    e in ArgumentError ->
      Logger.error(fn -> "Failed to write to InfluxDB: #{inspect(e)}" end)
      conn
  end
end
