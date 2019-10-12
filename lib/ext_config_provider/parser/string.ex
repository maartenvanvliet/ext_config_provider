defmodule ExtConfigProvider.Parser.String do
  @moduledoc """
  Simple parser that accepts the value of the config and returns it
  """
  def decode!(string), do: string
end
