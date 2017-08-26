defmodule Elixml.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixml,
      version: "0.1.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env == :prod,
      name: "elixml",
      description: "Easy to use xml lib. Allow to parse, compose and generate xml data",
      package: [
        files: ["lib", "config", "mix.exs", "LICENSE", "README*"],
        maintainers: ["Marcus Lankenau"],
        licenses: ["Apache 2.0"],
        links: %{"GitHub" => "https://github.com/mlankenau/elixml"}
      ],
      source_url: "https://github.com/mlankenau/elixml",
      deps: deps()
    ]
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
    ]
  end
end
