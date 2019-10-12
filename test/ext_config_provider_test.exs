defmodule ExtConfigProviderTest do
  use ExUnit.Case

  defmodule MockJsonClient do
    def get_config(path, []) do
      send(self(), {:get_config, path})

      """
      {"app": {
        "k": "test_config"
        }
      }
      """
    end
  end

  defmodule MockStringClient do
    def get_config(path, []) do
      send(self(), {:get_config, path})
      "secret_bogus_value"
    end
  end

  describe "init/1" do
    test "initializes with list" do
      assert ExtConfigProvider.init(path: "test") == [path: "test"]
    end

    test "initializes with string" do
      assert ExtConfigProvider.init("test") == [path: "test"]
    end
  end

  describe "load/2" do
    test "handles json values" do
      assert ExtConfigProvider.load([app: [k: :v1]], path: "test", client: MockJsonClient) == [
               app: [k: "test_config"]
             ]

      assert_received({:get_config, "test"})
    end

    test "handles string values" do
      assert ExtConfigProvider.load([app: [k: :v1]],
               path: "test",
               parser: ExtConfigProvider.Parser.String,
               client: MockStringClient,
               transformer: ExtConfigProvider.Transformer.Value,
               merge_strategy: ExtConfigProvider.MergeStrategy.Path,
               config_path: [:app, :k]
             ) == [app: [k: "secret_bogus_value"]]

      assert_received({:get_config, "test"})
    end
  end

  defmodule TestConfigProvider do
    use ExtConfigProvider,
      parser: ExtConfigProvider.Parser.String,
      client: MockStringClient,
      transformer: ExtConfigProvider.Transformer.Value,
      merge_strategy: ExtConfigProvider.MergeStrategy.Path,
      config_path: [:app, :l]
  end

  describe "convenience macro" do
    test "gets configuration" do
      opts = TestConfigProvider.init(path: "test")

      assert TestConfigProvider.load([app: [k: :v1]], opts) == [
               app: [l: "secret_bogus_value", k: :v1]
             ]

      assert_received({:get_config, "test"})
    end
  end
end
