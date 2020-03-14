defmodule HoodMelville.MixProject do
  use Mix.Project

  def project do
    [
      app: :hood_melville,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      # Docs
      name: "Hood Melville Queue",
      source_url: "https://github.com/IRog/hood_melville",
      homepage_url: "https://github.com/IRog/hood_melville",
      docs: [
        # The main page in the docs
        main: "HoodMelville",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
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
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev], runtime: false},
      {:propcheck, "~> 1.1", only: [:test, :dev]},
      {:excoveralls, "~> 0.10", only: :test},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:benchee, "~> 1.0", only: :dev},
      {:benchee_html, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Real-time purely functional persistent (in the data-structure sense not that it's goes to disk) queue"
  end

  defp package() do
    [
      name: "hood_melville",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/IRog/hood_melville"}
    ]
  end
end
