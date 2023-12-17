import { modFox, modScene, togglePoopBag, writeModal } from "./ui";
import {
  RAIN_CHANCE,
  SCENE,
  DAY_LENGTH,
  NIGHT_LENGTH,
  getNextHungerTime,
  getNextDieTime,
  getNextPoopTime,
} from "./constants";

const gameState = {
  current: "INIT",
  clock: 1,
  wakeTime: -1,
  sleepTime: -1,
  dieTime: -1,
  hungryTime: -1,
  timeToStartCelebrating: -1,
  timeToEndCelebrating: -1,
  poopTime: -1,

  tick() {
    this.clock++;
    console.log("clock", this.clock);

    if (this.clock === this.wakeTime) {
      return this.wake();
    } else if (this.clock === this.sleepTime) {
      return this.sleep();
    } else if (this.clock === this.hungryTime) {
      return this.getHungry();
    } else if (this.clock === this.dieTime) {
      return this.die();
    } else if (this.clock === this.timeToStartCelebrating) {
      return this.startCelebrating();
    } else if (this.clock === this.timeToEndCelebrating) {
      return this.endCelebrating();
    } else if (this.clock === this.poopTime) {
      return this.poop();
    }
    return this.clock;
  },
  startGame() {
    this.current = "HATCHING";
    this.wakeTime = this.clock + 3;
    modFox("egg");
    modScene("day");
    writeModal();
  },
  wake() {
    console.log("awoken");

    this.wakeTime = -1;
    modFox("idling");
    this.scene = Math.random() > RAIN_CHANCE ? 0 : 1;
    modScene(SCENE[this.scene]);
    this.sleepTime = DAY_LENGTH + this.clock;
    this.hungryTime = getNextHungerTime(this.clock);
    this.determineFoxState();
    //set the day
  },
  sleep() {
    this.state = "SLEEP";
    modFox("sleep");
    modScene("night");
    this.clearTimes();
    this.wakeTime = NIGHT_LENGTH + this.clock;
  },
  getHungry() {
    this.current = "HUNGRY";
    this.dieTime = getNextDieTime(this.clock);
    this.hungryTime = -1;
    modFox("hungry");
  },
  die() {
    this.current = "DEAD";
    modScene("dead");
    modFox("dead");
    this.clearTimes();
    writeModal("The fox died :( <br/> Press the middle button to start");
  },

  poop() {
    this.current = "POOPING";
    this.poopTime = -1;
    this.dieTime = getNextDieTime(this.clock);
    modFox("pooping");
  },
  clearTimes() {
    this.wakeTime = -1;
    this.sleepTime = -1;
    this.dieTime = -1;
    this.timeToEndCelebrating = -1;
    this.timeToStartCelebrating = -1;
    this.poopTime = -1;
    this.hungryTime = -1;
  },

  startCelebrating() {
    this.current = "CELEBRATING";
    modFox("celebrate");
    this.timeToStartCelebrating = -1;
    this.timeToEndCelebrating = this.clock + 2;
  },
  endCelebrating() {
    this.current = "IDLING";

    this.timeToEndCelebrating = -1;
    this.determineFoxState();
    togglePoopBag(false);
  },
  determineFoxState() {
    if (this.current === "IDLING") {
      if (SCENE[this.scene] == "rain") {
        modFox("rain");
      } else {
        modFox("idling");
      }
    }
  },
  handleUsersActions(icon) {
    if (
      ["SLEEP", "FEEDING", "HATCHING", "CELEBRATING"].includes(this.current)
    ) {
      //can't do anything
      return;
    }

    if (["INIT", "DEAD"].includes(this.current)) {
      this.startGame();
      //new game
      return;
    }

    switch (icon) {
      case "weather":
        this.changeWeather();
        break;
      case "poop":
        this.cleanUpPoop();
        break;
      case "fish":
        this.feed();
        break;
    }
    //types of icons
  },

  changeWeather() {
    this.scene = (this.scene + 1) % SCENE.length;
    modScene(SCENE[this.scene]);
    this.determineFoxState();
  },
  cleanUpPoop() {
    if (this.current === "POOPING") {
      this.dieTime = -1;
      togglePoopBag(true);
      this.startCelebrating();
      this.hungryTime = getNextHungerTime(this.clock);
    }
  },
  feed() {
    if (this.current !== "HUNGRY") {
      return;
    }
    this.current = "FEEDING";
    this.dieTime = -1;
    this.poopTime = getNextPoopTime(this.clock);
    modFox("eating");
    this.timeToStartCelebrating = this.clock + 2;
  },
};

//machine state pattern

export const handleUsersActions = gameState.handleUsersActions.bind(gameState);
//always will be the gameState
export default gameState;
