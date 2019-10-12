defmodule ExtConfigProvider.Client do
  @moduledoc """
  Behaviour for the AWS Client

  Expects a `config_key`, which will be the key the parameter is stored under.
  And a list of `config_overrides` to override the configuration for the AWS client.
  """
  @callback get_config(config_key :: binary, config_overrides :: list) :: binary
end
