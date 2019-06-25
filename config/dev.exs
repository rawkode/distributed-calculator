use Mix.Config

config :logger,
  backends: [
    :console
    # Logger.Backends.Syslog
  ],
  level: :debug,
  syslog: [
    host: "telegraf",
    port: 6514,
    appid: "calculator",
    facility: :local1
  ]

config :opencensus, :reporters,
  oc_reporter_jaeger: [
    hostname: "jaeger",
    port: 16686,
    service_name: "calculator",
    service_tags: %{"key" => "value"}
  ]

import_config("runtime.exs")
