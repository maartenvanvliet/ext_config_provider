defmodule ExtConfigProvider.MergeStrategy.PathTest do
  use ExUnit.Case
  doctest ExtConfigProvider.MergeStrategy.Path
  alias ExtConfigProvider.MergeStrategy.Path

  test "merges config keyword lists" do
    existing_config = [toplevel: [a: 1, b: 2]]
    new_config = "some value"

    assert Path.apply(new_config, existing_config, config_path: [:toplevel, :a]) == [
             toplevel: [{:a, "some value"}, {:b, 2}]
           ]
  end
end
