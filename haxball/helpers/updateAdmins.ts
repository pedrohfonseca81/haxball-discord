export const updateAdmins = (room: any, player: any) => {
  var players = room.getPlayerList();
  if (players.length == 0) return;
  if (players.find((player: any) => player.admin) != null) return;
  room.setPlayerAdmin(players[0].id, true);
};
