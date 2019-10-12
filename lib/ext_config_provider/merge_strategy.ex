defmodule ExtConfigProvider.MergeStrategy do
  @moduledoc """
  Strategy behaviour.
  Determines how to merge the retrieved config with the existing config in your
  application.
  """
  @callback apply(config :: list, existing_config :: list, opts :: list) :: list
end
