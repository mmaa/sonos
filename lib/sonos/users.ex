defmodule Sonos.Users do
  alias Sonos.Schemas.User

  def initialize(data) do
    data.users
    |> Enum.map(fn user -> User.changeset(%User{}, user) end)
    |> Enum.filter(fn changeset -> changeset.valid? end)
    |> Enum.map(fn changeset -> Map.merge(%User{}, changeset.changes) end)
  end

  def upsert_user(users, name, data) do
    existing_user_index = Enum.find_index(users, &(&1.name == name))

    if existing_user_index do
      update_user(users, existing_user_index, data)
    else
      create_user(users, name, data)
    end
  end

  defp update_user(users, index, data) do
    {existing_user, users} = List.pop_at(users, index)

    attrs = %{
      access_token: data.access_token,
      expires_at: DateTime.add(DateTime.utc_now(), data.expires_in),
      refresh_token: data.refresh_token
    }

    changeset = User.changeset(existing_user, attrs)

    if changeset.valid? do
      [Map.merge(existing_user, changeset.changes) | users]
    else
      [existing_user | users]
    end
  end

  defp create_user(users, name, data) do
    attrs = %{
      name: name,
      access_token: data.access_token,
      expires_at: DateTime.add(DateTime.utc_now(), data.expires_in),
      refresh_token: data.refresh_token
    }

    changeset = User.changeset(%User{}, attrs)

    if changeset.valid? do
      [Map.merge(%User{}, changeset.changes) | users]
    else
      users
    end
  end
end
