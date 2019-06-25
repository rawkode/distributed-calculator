defmodule Calculator.MixProject do
  use Mix.Project

  def project do
    [
      app: :calculator,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:abacus, :logger, :plug_cowboy, :prometheus, :syslog],
      mod: {Calculator.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:abacus, "~> 0.4.2"},
      {:distillery, "~> 2.1.0"},
      {:hackney, "~> 1.14.0"},
      {:instream, "~> 0.21"},
      {:jason, ">= 1.0.0"},
      {:logger_file_backend, "~> 0.0.10"},
      {:opencensus, "~> 0.9", override: true},
      {:opencensus_elixir, "~> 0.3.0"},
      {:opencensus_jaeger, "~> 0.0.1"},
      {:opencensus_plug, "~> 0.3.0"},
      {:opencensus_tesla, "~> 0.2.1"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, ">= 3.0.0"},
      {:prometheus, "~> 4.4.0"},
      {:prometheus_plugs, "~> 1.1.1"},
      {:prometheus_process_collector, "~> 1.4.3"},
      {:syslog, github: "smpallen99/syslog"},
      {:tesla, "~> 1.2.1"}
    ]
  end
end
