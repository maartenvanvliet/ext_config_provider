defmodule ExtConfigProvider.MergeStrategy.DefaultTest do
  use ExUnit.Case
  doctest ExtConfigProvider.MergeStrategy.Default

  alias ExtConfigProvider.MergeStrategy.Default

  test "merges config keyword lists" do
    existing_config = [toplevel: [a: 1]]
    new_config = [toplevel: ["Elixir.Some.Module": "config"]]

    assert Default.apply(new_config, existing_config, []) == [
             toplevel: [{:a, 1}, {Some.Module, "config"}]
           ]
  end
end
