defmodule ExtConfigProvider.Transformer.DefaultTest do
  use ExUnit.Case
  doctest ExtConfigProvider.Transformer.Default
  alias ExtConfigProvider.Transformer.Default

  test "transforms map to keyword list" do
    assert Default.apply(%{"a" => 1}) == [a: 1]
  end

  test "transforms nested map and converts to module atoms" do
    assert Default.apply(%{"toplevel" => %{"Some.Module" => "config"}}) == [
             toplevel: ["Elixir.Some.Module": "config"]
           ]
  end
end
