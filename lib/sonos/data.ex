defmodule Sonos.Data do
  @path "~/bin/data/sonos.json"

  def read do
    Path.expand(@path)
    |> File.read!()
    |> Jason.decode!(keys: :atoms)
  end

  def write(integration, users) do
    data = %{integration: integration, users: users}
    json = Jason.encode!(data, pretty: true)

    Path.expand(@path)
    |> File.write!(json)
  end
end
