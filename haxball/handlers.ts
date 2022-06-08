import { Channel } from "phoenix";

export const registerHandlers = (room: any, channel: Channel) => {
  channel.on("room:discord_message", (data) => room.sendAnnouncement(`${data.author}: ${data.message}`));
  channel.on("room:dm_msg", (data) => room.sendAnnouncement(`${data.author}: ${data.message}`, Number(data.id)));
  channel.on("room:clearbans", () => room.clearBans());
  channel.on("room:adm", (data) => room.setPlayerAdmin(data.id, true));
  channel.on("room:remove_adm", (data) => room.setPlayerAdmin(data.id, false));
  channel.on("room:ban", (data) => room.kickPlayer(data.id, null, true));
  channel.on("room:kick", (data) => room.kickPlayer(data.id, null, false));
  channel.on("room:eval", (data) => {
    const result = eval(data.code);

    channel.push("room:eval", { ...data, result });
  });
};
