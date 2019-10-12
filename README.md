# Aws Config Provider
[![Hex pm](http://img.shields.io/hexpm/v/ext_config_provider.svg?style=flat)](https://hex.pm/packages/ext_config_provider) [![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg)](https://hexdocs.pm/ext_config_provider) [![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
-----

Flexible Config Provider for e.g. AWS Parameter Store/Secrets Manager

Fetch your configuration at the start of the application from AWS Parameter Store
or the Secrets Manager. The format of your secrets can be json/toml or any other format. There's also flexibility in how the secrets are applied to your config.

## Installation

The package can be installed by adding `ext_config_provider` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ext_config_provider, "~> 1.0.1"}
  ]
end
```

The AWS Parameter Store/Secrets Manager are packaged config providers. They need ExAws to be configured and have the right IAM permissions to work.

## Adding a config provider

```elixir
  def project do
    [
      app: :example,
      ...
      releases: [
        example: [
          config_providers: [{ExtConfigProvider, [path: "parameter_name"]}]
        ]
      ]
    ]
  end
```

The config provider can take several options. See `ExtConfigProvider.init/1`

A macro can also be used to build a config provider

```elixir
  defmodule Example.ConfigProvider do
    use ExtConfigProvider,
      parser: ExtConfigProvider.Parser.String,
      transformer: ExtConfigProvider.Transformer.Value,
      merge_strategy: ExtConfigProvider.MergeStrategy.Path,
      config_path: [:app, :secret]
  end
```
You can add this config provider in the usual fashion:

```elixir
  releases: [
    example: [
      config_providers: [{Example.ConfigProvider, [path: "parameter_name"]}]
    ]
  ]
```

Inspired by https://github.com/christopherlai/secrets_manager_provider

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ext_config_provider](https://hexdocs.pm/ext_config_provider).

