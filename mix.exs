defmodule AntiTracking.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        bot: [
          version: "0.0.1",
          include_executables_for: [:unix],
          applications: [web: :permanent, storages: :permanent, bot: :permanent]
        ]
      ]
    ]
  end

  defp deps do
    []
  end
end
