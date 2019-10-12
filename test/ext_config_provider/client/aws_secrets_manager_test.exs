defmodule ExtConfigProvider.Client.AwsSecretsManagerTest do
  use ExUnit.Case

  alias ExtConfigProvider.Client.AwsSecretsManager

  defmodule MockExAws do
    @error {:http_error, 400,
            %{
              body:
                "{\"__type\":\"ResourceNotFoundException\",\"Message\":\"Secrets Manager can’t find the specified secret.\"}",
              headers: [
                {"Date", "Sat, 12 Oct 2019 09:11:58 GMT"},
                {"Content-Type", "application/x-amz-json-1.1"},
                {"Content-Length", "101"},
                {"Connection", "keep-alive"},
                {"x-amzn-RequestId", "cb6a3de2-569a-4241-adcb-dea8b9fc97c2"}
              ],
              status_code: 400
            }}

    @success %{
      "ARN" => "arn:aws:secretsmanager:eu-west-2:bogus:secret:prod/example-nMryPd",
      "CreatedDate" => 1_570_567_750.857,
      "Name" => "prod/example",
      "SecretString" => "test value",
      "VersionId" => "0f845195-6e87-4da7-9ba4-e25bca627b1e",
      "VersionStages" => ["AWSCURRENT"]
    }

    def request(%{data: %{"SecretId" => "bogus"}}, _) do
      {:error, @error}
    end

    def request(%{data: %{"SecretId" => name}}, config_overrides) do
      send(self(), {:request, name, config_overrides})
      {:ok, @success}
    end
  end

  test "returns value in secrets manager" do
    assert AwsSecretsManager.get_config("test_path", [], MockExAws) == "test value"

    assert_received({:request, "test_path", _})
  end

  test "returns error for unknown parameter" do
    assert {:error, _} = AwsSecretsManager.get_config("bogus", [], MockExAws)
  end

  test "overrides config in aws calls" do
    assert AwsSecretsManager.get_config("test_path", [region: "us-bogus-2"], MockExAws) ==
             "test value"

    assert_received({:request, "test_path", overrides})
    assert overrides == [region: "us-bogus-2"]
  end
end
