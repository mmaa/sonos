defmodule Sonos.Data do
  def read do
    File.read!("data/sonos.json")
    |> Jason.decode!(keys: :atoms)
  end

  def write(integration, users) do
    data = %{integration: integration, users: users}
    json = Jason.encode!(data, pretty: true)

    File.write!("data/sonos.json", json)
  end
end
