defmodule Server.Discord.Commands do
  alias Nostrum.Api
  alias ServerWeb.Endpoint
  alias Server.Presence

  def handle_command({"ban", args, msg}) do
    [id | _message] = args

    Endpoint.broadcast("messages", "room:ban", %{
      "id" => id
    })

    Api.create_message(msg.channel_id, "The player #{id} has been succesfully banned.")
  end

  def handle_command({"kick", args, msg}) do
    [id | _message] = args

    Endpoint.broadcast("messages", "room:kick", %{
      "id" => id
    })

    Api.create_message(msg.channel_id, "The player #{id} has been succesfully kicked.")
  end

  def handle_command({"clearbans", args, msg}) do
    Endpoint.broadcast("messages", "room:clearbans", %{})

    Api.create_message(msg.channel_id, "The ban list has been cleared.")
  end

  def handle_command({"send", args, msg}) do
    [id | message] = args

    Endpoint.broadcast("messages", "room:dm_msg", %{
      "id" => id,
      "author" => msg.member.nick,
      "message" => message |> Enum.join(" ")
    })
  end

  def handle_command({"users", args, msg}) do
    users = Presence.list("users")

    case users |> Enum.any?() do
      true ->
        user_list =
          users
          |> Enum.map(fn {_id, data} -> data[:metas] |> List.first() end)

        list = for x <- user_list, do: "#{x["name"]}: #{x["id"]}"

        Api.create_message(msg.channel_id, list |> Enum.join("\n"))

      false ->
        nil
    end
  end

  def handle_command({"adm", args, msg}) do
    [id | _message] = args

    Endpoint.broadcast("messages", "room:adm", %{
      "id" => id
    })
  end

  def handle_command({"tiraradm", args, msg}) do
    [id | _message] = args

    Endpoint.broadcast("messages", "room:remove_adm", %{
      "id" => id
    })
  end

  def handle_command({"eval", args, msg}) do
    Endpoint.broadcast("messages", "room:eval", %{
      "code" => args |> Enum.join(" "),
      "channel_id" => msg.channel_id |> Integer.to_string()
    })
  end

  def handle_command({_, _, _}) do
    :noop
  end
end
