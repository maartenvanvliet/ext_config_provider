defmodule ExtConfigProvider do
  @external_resource "./README.md"
  @moduledoc """
  #{File.read!(@external_resource) |> String.split("-----", parts: 2) |> List.last()}
  """
  @behaviour Config.Provider

  defmacro __using__(opts) do
    quote do
      @defaults unquote(opts)

      def init(opts) do
        opts = Keyword.merge(@defaults, opts)

        ExtConfigProvider.init(opts)
      end

      def load(config, opts) do
        ExtConfigProvider.load(config, opts)
      end

      defoverridable load: 2, init: 1
    end
  end

  @impl true
  @doc """
  Accepts list of opts:

    * `:path` -- (required) the key of the parameter. If supplied a tuple `{:env, "env"}`, the specified env var will be used as the path.
    * `:parser` -- how to parse the retrieved parameter, defaults to `Jason`
    * `:transformer` -- transform the parsed value to a configuration, defaults to `ExtConfigProvider.Transformer.Default`
    * `:merge_strategy` -- how to apply the configuration to the existing configuration, defaults to `ExtConfigProvider.MergeStrategy.Default`
    * `:client` -- Which client to use to get the parameter, defaults to `ExtConfigProvider.Client.ParameterStore`
    * `:client_opts` -- keyword list to pass to the client to override e.g. region
  """
  def init(opts) when is_binary(opts) do
    init(path: opts)
  end

  def init(opts) when is_list(opts), do: opts

  @impl true
  def load(config, opts) do
    parser = Keyword.get(opts, :parser, Jason)
    transformer = Keyword.get(opts, :transformer, ExtConfigProvider.Transformer.Default)
    merge_strategy = Keyword.get(opts, :merge_strategy, ExtConfigProvider.MergeStrategy.Default)
    client = Keyword.get(opts, :client, ExtConfigProvider.Client.AwsParameterStore)
    path = Keyword.fetch!(opts, :path)
    client_opts = Keyword.get(opts, :client_opts, [])

    path
    |> retrieve_param
    |> client.get_config(client_opts)
    |> parser.decode!
    |> transformer.apply
    |> merge_strategy.apply(config, opts)
  end

  @spec retrieve_param(binary | {:env, any}) :: binary
  defp retrieve_param(path) when is_binary(path) do
    path
  end

  defp retrieve_param({:env, env_var}) do
    System.get_env(env_var)
  end
end
