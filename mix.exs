defmodule Sonos.MixProject do
  use Mix.Project

  def project do
    [
      app: :sonos,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  def escript do
    [main_module: Sonos.CLI]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.7"},
      {:ecto, "~> 3.4"}
    ]
  end
end
