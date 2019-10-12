defmodule ExtConfigProvider.MergeStrategy.Default do
  @moduledoc """
  Strategy to merge the retrieved secrets as a keyword list into the current
  configuration.
  """
  @behaviour ExtConfigProvider.MergeStrategy

  @doc """
  Example

    iex> existing_config = [toplevel: [a: 1]]
    iex> new_config = [toplevel: ["Some.Module": "config"]]
    iex> ExtConfigProvider.MergeStrategy.Default.apply(new_config, existing_config, [])
    [toplevel: [a: 1, "Some.Module": "config"]]

  """
  def apply(new_config, config, _opts) do
    Config.Reader.merge(config, new_config)
  end
end
