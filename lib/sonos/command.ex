defmodule Sonos.Command do
  alias Sonos.Client

  def set_preferences(user) do
    %{households: households} = Client.command_get(user, "/households")

    for household <- households do
      %{players: players} =
        Client.command_get(user, "/households/#{household.id}/groups")

      for player <- Enum.filter(players, &(&1.name == user.player)) do
        Client.command_post(
          user,
          "/players/#{player.id}/homeTheater/options",
          %{nightMode: user.night_mode, enhanceDialog: user.enhance_dialog}
        )

        Client.command_post(
          user,
          "/players/#{player.id}/playerVolume",
          %{volume: 10, muted: false}
        )
      end
    end
  end
end
