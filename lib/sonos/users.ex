defmodule Sonos.Users do
  alias Sonos.Schemas.User

  def initialize(data) do
    data.users
    |> Enum.map(fn user -> User.changeset(%User{}, user) end)
    |> Enum.filter(fn changeset -> changeset.valid? end)
    |> Enum.map(fn changeset -> Map.merge(%User{}, changeset.changes) end)
  end
end
