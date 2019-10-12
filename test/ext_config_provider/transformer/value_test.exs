defmodule ExtConfigProvider.Transformer.ValueTest do
  use ExUnit.Case

  alias ExtConfigProvider.Transformer.Value

  test "transform is noop" do
    assert Value.apply("test") == "test"
  end
end
