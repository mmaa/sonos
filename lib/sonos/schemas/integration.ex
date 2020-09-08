defmodule Sonos.Schemas.Integration do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:id]}

  embedded_schema do
    field :key, Ecto.UUID
    field :secret, Ecto.UUID
    field :redirect_url, :string
  end

  def changeset(integration, attrs) do
    integration
    |> cast(attrs, [
      :key,
      :secret,
      :redirect_url
    ])
    |> validate_required([
      :key,
      :secret,
      :redirect_url
    ])
  end
end
