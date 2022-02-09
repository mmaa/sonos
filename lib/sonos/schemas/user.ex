defmodule Sonos.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:id]}

  embedded_schema do
    field :name, :string
    field :refresh_token, :string
    field :access_token, :string
    field :expires_at, :utc_datetime
    field :player, :string
    field :night_mode, :boolean, default: false
    field :enhance_dialog, :boolean, default: false
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :refresh_token,
      :access_token,
      :expires_at,
      :player,
      :night_mode,
      :enhance_dialog
    ])
    |> validate_required([
      :name,
      :refresh_token,
      :access_token,
      :expires_at,
      :player,
      :night_mode,
      :enhance_dialog
    ])
  end
end
