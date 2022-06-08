defmodule Server.Discord.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Server.Discord.Commands

  @prefix "!"

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    messages = 984_123_507_971_616_768

    if msg.channel_id === messages && !msg.author.bot do
      ServerWeb.Endpoint.broadcast("messages", "room:discord_message", %{
        "author" => msg.member.nick || "bot",
        "message" => msg.content
      })
    end

    [command | args] =
      msg.content
      |> String.trim_leading(@prefix)
      |> String.split()

    Commands.handle_command({command |> String.downcase(), args, msg})
  end

  def handle_event(_event) do
    :noop
  end
end
