defmodule Sonos.Client do
  @auth_host "api.sonos.com"
  @auth_path "/login/v3/oauth"
  @auth_access_path "/login/v3/oauth/access"
  @command_host "api.ws.sonos.com"
  @command_path "/control/api/v1"

  def auth_url(%{key: key, redirect_url: redirect_url}) do
    auth_uri(key, redirect_url)
    |> URI.to_string()
  end

  def get_tokens(integration, code) do
    form = [
      grant_type: "authorization_code",
      code: code,
      redirect_uri: integration.redirect_url
    ]

    handle_tokens(integration, form)
  end

  def refresh_token(integration, user) do
    form = [
      grant_type: "refresh_token",
      refresh_token: user.refresh_token
    ]

    handle_tokens(integration, form)
  end

  def command_get(user, endpoint) do
    command_uri(endpoint)
    |> URI.to_string()
    |> HTTPoison.get(Authorization: "Bearer #{user.access_token}")
    |> handle_response()
  end

  def command_post(user, endpoint, body) do
    command_uri(endpoint)
    |> URI.to_string()
    |> HTTPoison.post(
      Jason.encode!(body),
      [
        {"Authorization", "Bearer #{user.access_token}"},
        {"Content-Type", "application/json"}
      ]
    )
    |> handle_response()
  end

  defp handle_tokens(integration, form) do
    token_uri()
    |> URI.to_string()
    |> HTTPoison.post({:form, form}, [],
      hackney: [basic_auth: {integration.key, integration.secret}]
    )
    |> handle_response()
  end

  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body, keys: :atoms)

      {:ok, %HTTPoison.Response{body: body}} ->
        raise body

      {:error, %HTTPoison.Error{reason: reason}} ->
        raise reason
    end
  end

  defp command_uri(endpoint) do
    %URI{
      scheme: "https",
      host: @command_host,
      path: @command_path <> endpoint
    }
  end

  defp token_uri do
    %URI{
      scheme: "https",
      host: @auth_host,
      path: @auth_access_path
    }
  end

  defp auth_uri(key, redirect_url) do
    %URI{
      scheme: "https",
      host: @auth_host,
      path: @auth_path,
      query:
        URI.encode_query([
          {"client_id", key},
          {"redirect_uri", redirect_url},
          {"response_type", "code"},
          {"state", "state"},
          {"scope", "playback-control-all"}
        ])
    }
  end
end
