defmodule ExtConfigProvider.Client.AwsSecretsManager do
  @moduledoc """
  The SecretsManager Client queries the AWS Secrets Manager

  Requires the `ExAws` and `ExAws.SecretsManager` packages.

  The profile making the api call needs [`secretsmanager:GetSecretValue`](https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html) permission on the resource.

  """
  @behaviour ExtConfigProvider.Client

  require Logger

  @impl true
  @doc """
  Get config for given key. `config_overrides` are passed on to `ExAws.request/2`.

  Example

    AwsSecretsManager.get_config("app/prod")

    AwsSecretsManager.get_config("app/prod", [region: "eu-west-1"])
  """
  def get_config(path, config_overrides \\ [], api_client \\ ExAws) do
    {:ok, _deps} = Application.ensure_all_started(:hackney)
    {:ok, _deps} = Application.ensure_all_started(:ex_aws)

    path
    |> ExAws.SecretsManager.get_secret_value()
    |> api_client.request(config_overrides)
    |> handle_response()
  end

  defp handle_response({:ok, resp}) do
    get_in(resp, ["SecretString"])
  end

  defp handle_response({:error, reason}) do
    Logger.error("Unable to fetch secrets from AWS Secrets Manager. Reason: #{inspect(reason)}")
    {:error, reason}
  end
end
