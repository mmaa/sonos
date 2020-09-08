defmodule Sonos.CLI do
  alias Sonos.{Data, Client, Integration, Users, Command}

  def main(args) do
    {options, _} = parse_args(args)

    data = Data.read()
    integration = Integration.initialize(data)
    users = Users.initialize(data)

    case options |> Keyword.keys() |> Enum.sort() do
      [:auth] ->
        integration
        |> Client.auth_url()
        |> IO.puts()

      [:code, :user] ->
        users =
          authorize_user(integration, users, options[:user], options[:code])

        Data.write(integration, users)

      [] ->
        checked_users = check_tokens(integration, users)

        unless checked_users == users do
          Data.write(integration, checked_users)
        end

        for user <- checked_users do
          Command.set_preferences(user)
        end
    end
  end

  defp authorize_user(integration, users, name, code) do
    data = Client.get_tokens(integration, code)
    Users.upsert_user(users, name, data)
  end

  defp check_tokens(integration, users) do
    users
    |> Enum.map(fn user ->
      if DateTime.diff(user.expires_at, DateTime.utc_now()) < 60 do
        data = Client.refresh_token(integration, user)

        Users.upsert_user(users, user.name, data)
        |> List.first()
      else
        user
      end
    end)
  end

  defp parse_args(args) do
    OptionParser.parse!(
      args,
      strict: [
        auth: :boolean,
        code: :string,
        user: :string
      ]
    )
  end
end
