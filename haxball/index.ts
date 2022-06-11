import { Socket } from "phoenix";
import { registerHandlers } from "./handlers";
import { parseConfig } from "./helpers/parseConfig";
import { updateAdmins } from "./helpers/updateAdmins";
import { FUTSAL_X3 } from "./src/maps";

const socket = new Socket("ws://localhost:4000/socket", { params: { userToken: "123" } });
const channel = socket.channel("room:lobby", { token: "123" });

channel.join();

socket.connect();

async function main({ config }: any) {
  const roomConfig = parseConfig(config);
  const room = (window as any).HBInit(roomConfig);

  room.setCustomStadium(FUTSAL_X3);

  room.onPlayerJoin = (player: any) => {
    updateAdmins(room, player);

    channel.push("room:on_player_join", { player });
  };

  room.onPlayerLeave = (player: any) => channel.push("room:on_player_leave", { player });

  room.onPlayerChat = (player: any, message: string) => {
    channel.push("room:on_player_chat", { player, message });

    room.sendAnnouncement(`${player.name}: ${message}`);

    return false;
  };

  registerHandlers(room, channel);
}

channel.push("room:open", {});

channel.on("room:open", main);
