use Mix.Config

config :calculator, Calculator.InfluxDB,
  database: System.get_env("INFLUXDB_DB"),
  host: System.get_env("INFLUXDB_HOST"),
  pool: [max_overflow: 10, size: 50],
  port: String.to_integer(System.get_env("INFLUXDB_PORT")),
  scheme: "http",
  writer: Instream.Writer.Line
