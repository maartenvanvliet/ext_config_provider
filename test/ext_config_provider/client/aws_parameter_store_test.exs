defmodule ExtConfigProvider.Client.AwsParameterStoreTest do
  use ExUnit.Case

  alias ExtConfigProvider.Client.AwsParameterStore

  defmodule MockExAws do
    @error {:http_error, 400,
            %{
              body: "{\"__type\":\"ParameterNotFound\"}",
              headers: [
                {"x-amzn-RequestId", "9ad7eda6-d97a-4e37-8d2d-bogus"},
                {"Content-Type", "application/x-amz-json-1.1"},
                {"Content-Length", "30"},
                {"Date", "Fri, 11 Oct 2019 13:37:28 GMT"},
                {"Connection", "close"}
              ],
              status_code: 400
            }}

    @success %{
      "Parameter" => %{
        "ARN" => "arn:aws:ssm:eu-west-2:bogus:parameter/toml",
        "LastModifiedDate" => 1_570_567_750.899,
        "Name" => "toml",
        "Type" => "String",
        "Value" => "test value",
        "Version" => 5
      }
    }

    def request(%{data: %{"Name" => "bogus"}}, _) do
      {:error, @error}
    end

    def request(%{data: %{"Name" => name}}, config_overrides) do
      send(self(), {:request, name, config_overrides})
      {:ok, @success}
    end
  end

  test "returns value in parameter store" do
    assert AwsParameterStore.get_config("test_path", [], MockExAws) == "test value"

    assert_received({:request, "test_path", _})
  end

  test "returns error for unknown paramater" do
    assert {:error, _} = AwsParameterStore.get_config("bogus", [], MockExAws)
  end

  test "overrides config in aws calls" do
    assert AwsParameterStore.get_config("test_path", [region: "us-bogus-2"], MockExAws) ==
             "test value"

    assert_received({:request, "test_path", overrides})
    assert overrides == [region: "us-bogus-2"]
  end
end
