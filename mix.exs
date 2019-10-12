defmodule ExtConfigProvider.MixProject do
  use Mix.Project

  @url "https://github.com/maartenvanvliet/ext_config_provider"
  def project do
    [
      app: :ext_config_provider,
      version: "1.0.2",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "ExtConfigProvider",
      description: "Flexible Config Provider for e.g. AWS Parameter Store/Secrets Manager",
      package: [
        maintainers: ["Maarten van Vliet"],
        licenses: ["MIT"],
        links: %{"GitHub" => @url},
        files: ~w(LICENSE README.md lib mix.exs)
      ],
      docs: [
        main: "ExtConfigProvider",
        canonical: "http://hexdocs.pm/ext_config_provider",
        source_url: @url
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
      {:ex_aws, "~> 2.0", optional: true},
      {:ex_aws_ssm, "~> 2.0", optional: true},
      {:ex_aws_secretsmanager, "~> 2.0", optional: true},
      {:jason, "~> 1.1", optional: true, only: [:test, :dev]},
      {:hackney, "~> 1.9", optional: true},
      {:ex_doc, "~> 0.21", only: :dev},
      {:credo, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
