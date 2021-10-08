defmodule ElixirBench.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_bench,
      version: "0.1.0",
      elixir: "~> 1.12",
      test_paths: ["test", "lib"],
      test_pattern: "*_test.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirBench.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      ## xml parsing
      {:sweet_xml, "~> 0.7.1"},
      {:sax_map, "~> 1.0"},
      {:floki, "~> 0.5"},
      {:fast_xml, "~> 1.1.47"},
      {:xml_json, "~> 0.4"},

      ## json path
      {:warpath, "~> 0.6.2"},
      {:elixpath, "~> 0.1"},
      {:exjsonpath, "~> 0.1"},
      {:pathex, "~> 1.2.0"},
      {:telepath, "~> 0.1.0"},

      ## benchmarks
      {:benchee, "~> 1.0", only: [:dev, :test]},
      {:mix_test_interactive, "~> 1.0", only: :dev, runtime: false}
    ]
  end
end
