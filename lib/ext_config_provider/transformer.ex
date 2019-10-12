defmodule ExtConfigProvider.Transformer do
  @moduledoc """
  Behaviour to transform the result of the decoded config into a datastructure
  suitable for the merge strategy to work with.
  """
  @callback apply(map) :: list
end
