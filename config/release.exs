~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :prod do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :"MFqDA~8%cN9oaeGEZk`I^*[ooM??wnu/2)w*)0sXaeXuwVS*.,:NRv.(_9=bJIzB")

  set(
    config_providers: [
      {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
    ]
  )

  set(
    overlays: [
      {:copy, "config/runtime.exs", "etc/config.exs"}
    ]
  )
end

release :calculator do
  set(version: current_version(:calculator))

  set(
    applications: [
      :runtime_tools
    ]
  )
end
