defmodule Sonos.Integration do
  alias Sonos.Schemas.Integration

  def initialize(data) do
    changeset = Integration.changeset(%Integration{}, data.integration)

    if changeset.valid? do
      Map.merge(%Integration{}, changeset.changes)
    else
      raise inspect(changeset.errors)
    end
  end
end
