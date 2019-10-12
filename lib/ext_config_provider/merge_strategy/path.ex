defmodule ExtConfigProvider.MergeStrategy.Path do
  @moduledoc """
  Strategy to merge the retrieved secrets into a specific key in the config
  """
  @behaviour ExtConfigProvider.MergeStrategy

  @spec apply(any, keyword, keyword) :: keyword
  @doc """
  Merge the retrieved parameter into a specific configuration key

  Example

    iex> existing_config = [toplevel: ["Example.Repo": 1, b: 2]]
    iex> new_config = "some value"
    iex> key = [:toplevel, :"Example.Repo"]
    iex> ExtConfigProvider.MergeStrategy.Path.apply(new_config, existing_config, config_path: key)
    [toplevel: ["Example.Repo": "some value", b: 2]]

  """
  def apply(secret, existing_config, opts) do
    config_path = Keyword.fetch!(opts, :config_path)
    config = put_in(existing_config, config_path, secret)
    Config.Reader.merge(existing_config, config)
  end
end
