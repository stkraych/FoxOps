import { ICONS } from "./constants";

const toggleHighLighted = (icon, show) =>
  document
    .querySelector(`.${ICONS[icon]}-icon`)
    .classList.toggle("highlighted", show); //-->un/highlighted icons->false/true

export default function initButtons(handleUsersActions) {
  let selectIcon = 0;

  function buttonClick({ target }) {
    //Looping back around the icons
    if (target.classList.contains("left-btn")) {
      toggleHighLighted(selectIcon, false);
      selectIcon = (2 + selectIcon) % ICONS.length;
      toggleHighLighted(selectIcon, true);
    } else if (target.classList.contains("right-btn")) {
      toggleHighLighted(selectIcon, false);
      selectIcon = (1 + selectIcon) % ICONS.length;
      toggleHighLighted(selectIcon, true);
    } else {
      handleUsersActions(ICONS[selectIcon]);
      //inside game logic/state -user clicks on the button-feed, sleep etc
      //divide the UI and game logic
    }
  }

  document.querySelector(".buttons").addEventListener("click", buttonClick);
} //-->handles all user's interactions
