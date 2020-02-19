defmodule Postex.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :postex,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],

      # Hex
      description: "Dynamically updating, searchable, sortable datatables with Phoenix LiveView",
      package: package(),

      # Docs
      name: "Exzeitable",
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
      {:earmark, "~> 1.3"},
      {:makeup_elixir, "~> 0.14"}
    ]
  end
end
