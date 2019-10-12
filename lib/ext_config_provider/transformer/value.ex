defmodule ExtConfigProvider.Transformer.Value do
  @behaviour ExtConfigProvider.Transformer

  @moduledoc """
  Takes a value and returns it. Useful for when the value of in the store
  needs to be used directly
  """
  def apply(value) do
    value
  end
end
