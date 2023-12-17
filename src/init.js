import game, { handleUsersActions } from "./gameState";
import { TICK_RATE } from "./constants";
import initButtons from "./buttons";

//--->all the game's logic-eating, hungry, sleeping ,etc

function tick() {
  console.log("tick", Date.now());
}
async function init() {
  console.log("starting game");

  initButtons(handleUsersActions);

  let nextTimeTick = Date.now();

  function nextAnimationFrame() {
    const now = Date.now();

    if (nextTimeTick <= now) {
      game.tick();
      nextTimeTick = now + TICK_RATE;
    }

    requestAnimationFrame(nextAnimationFrame);
  }
  requestAnimationFrame(nextAnimationFrame);
}

init();
