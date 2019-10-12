defmodule ExtConfigProvider.Client.AwsParameterStore do
  @moduledoc """
  The ParameterStore Client queries the AWS SSM Parameter Store

  Requires the `ExAws` and `ExAws.SSM` packages.

  The profile making the api call needs [`ssm:GetParameter`](https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_GetParameter.html) permission on the resource.

  """

  require Logger

  @behaviour ExtConfigProvider.Client

  @impl true
  @doc """
  Get config for given key. `config_overrides` are passed on to `ExAws.request/2`.

  Example

    AwsParameterStore.get_config("app/prod")

    AwsParameterStore.get_config("app/prod", [region: "eu-west-1"])
  """
  def get_config(key, config_overrides \\ [], api_client \\ ExAws) do
    {:ok, _deps} = Application.ensure_all_started(:hackney)
    {:ok, _deps} = Application.ensure_all_started(:ex_aws)

    key
    |> ExAws.SSM.get_parameter(with_decryption: true)
    |> api_client.request(config_overrides)
    |> handle_response()
  end

  defp handle_response({:ok, resp}) do
    get_in(resp, ["Parameter", "Value"])
  end

  defp handle_response({:error, reason}) do
    Logger.error("Unable to fetch secrets from AWS Parameter Store. Reason: #{inspect(reason)}")
    {:error, reason}
  end
end
