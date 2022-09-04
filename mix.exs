defmodule Postex.MixProject do
  use Mix.Project

  @version "0.1.8"

  def project do
    [
      app: :postex,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],

      # Dialyzer
      dialyzer: [
        list_unused_filters: true,
        plt_local_path: "dialyzer",
        plt_core_path: "dialyzer",
        flags: [
          :underspecs,
          :unknown,
          :unmatched_returns,
          :extra_return,
          :missing_return
        ]
      ],

      # Hex
      description: "a simple static blog generator using markdown files",
      package: package(),

      # Docs
      name: "Postex",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Alan Vardy"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/alanvardy/postex"},
      files: [
        "lib/postex.ex",
        "lib/postex",
        "mix.exs",
        "README.md"
      ]
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "README",
      canonical: "http://hexdocs.pm/postex",
      source_url: "https://github.com/alanvardy/postex",
      filter_prefix: "Postex",
      extras: [
        "README.md": [filename: "README"],
        "CHANGELOG.md": [filename: "CHANGELOG"],
        "CSS.md": [filename: "CSS"]
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_html, "~> 3.2"},
      {:makeup_elixir, "~> 0.14"},
      {:earmark, "~> 1.4.20"},
      {:earmark_parser, "~> 1.4.18"},
      # Tooling
      {:ex_check, "~> 0.12", only: :dev, runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.13", only: :test, runtime: false},
      {:ex_doc, "~> 0.26", only: :dev, runtime: false},
      {:inch_ex, github: "rrrene/inch_ex", only: [:dev, :test]}
    ]
  end
end
