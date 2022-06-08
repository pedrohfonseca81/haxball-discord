defmodule ServerWeb.RoomChannel do
  use ServerWeb, :channel

  alias Server.Presence
  alias Nostrum.Api

  @impl true
  def join("room:lobby", _payload, socket) do
    ServerWeb.Endpoint.subscribe("messages")

    {:ok, "ok", socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("room:on_player_join", %{"player" => player}, socket) do
    channel_id = 984_123_507_971_616_768

    Api.create_message(channel_id, "#{player["name"]}(#{player["id"]}) entrou na sala!")

    Presence.track(self(), "users", player["id"], player)

    {:noreply, socket}
  end

  @impl true
  def handle_in("room:on_player_leave", %{"player" => player}, socket) do
    channel_id = 984_123_507_971_616_768

    Presence.untrack(self(), "users", player["id"])

    Api.create_message(channel_id, "#{player["name"]}(#{player["id"]}) saiu da sala!")

    {:noreply, socket}
  end

  @impl true
  def handle_in("room:on_player_chat", %{"player" => player, "message" => message}, socket) do
    channel_id = 984_123_507_971_616_768

    Presence.track(self(), "messages", player["id"], %{
      "player" => player,
      "message" => message
    })

    Api.create_message(channel_id, "#{player["name"]}: #{message}")

    {:noreply, socket}
  end

  @impl true
  def handle_in(
        "room:eval",
        data,
        socket
      ) do
    Api.create_message(
      data["channel_id"] |> String.to_integer(),
      "#{data["result"] || "No return"}"
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: event, payload: state}, socket) do
    broadcast(socket, event, state)

    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
