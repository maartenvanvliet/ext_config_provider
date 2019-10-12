defmodule ExtConfigProvider.Transformer.Default do
  @behaviour ExtConfigProvider.Transformer

  @moduledoc """
  Takes a map and transforms it to a keyword list suitable for elixir configuration.

  When keys in a map start with capital letters, they are assumed to refer to Elixir modules.
  """

  @doc """
  Example

    iex> ExtConfigProvider.Transformer.Default.apply(%{"Example.Repo" => %{"url" => "some_url"}})
    [{Example.Repo, [url: "some_url"]}]

  """
  def apply(config) when is_map(config) do
    for {k, v} <- config do
      k = to_atom(k)
      {k, apply(v)}
    end
  end

  def apply(value), do: value

  defp to_atom(<<k::utf8, _rest::binary>> = key) when k >= ?A and k <= ?Z do
    Module.concat([key])
  end

  defp to_atom(key), do: String.to_atom(key)
end
