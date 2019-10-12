defmodule ExtConfigProvider.Parser do
  @moduledoc """
  Behaviour to take the parameter and convert it. E.g. convert json, toml or
  plain strings to something for your application to deal with.
  """
  @callback decode!(binary) :: map
end
