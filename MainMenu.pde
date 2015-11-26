class MainMenu extends AbstractScene {
     MainMenu() {
         super("Main Menu", "main_menu", "main_menu", Extension.JPG);
         addEvent(COLORS.get("red"), new SwitchScene(GAME_TYPE_ID, Direction.NEXT));
         //addEvent(COLORS.get("green"), new SwitchScene(SCORES_ID));
         //addEvent(COLORS.get("blue"), new SwitchScene(CREDITS_ID));
         addAnimation(new TitleAnimation("Main Title Animation", "main_menu", "title", Extension.PNG, 4, new Position(width / 2, 7 * height / 24), frameRate * 2));
     }
}

class Scores extends AbstractScene {
    Scores() {
         super("Scores", "scores", "scores", Extension.JPG);
         addEvent(COLORS.get("red"), new SwitchScene(MAIN_MENU_ID));
         addAnimation(new TitleAnimation("Scores Animation", "scores", "title", Extension.PNG, 4, new Position(width / 2, height / 2), frameRate * 2));
    }
}

class Credits extends AbstractScene {
    Credits() {
         super("Credits", "credits", "credits", Extension.JPG);
         addEvent(COLORS.get("red"), new SwitchScene(MAIN_MENU_ID));
         addAnimation(new TitleAnimation("Credits Animation", "scores", "title", Extension.PNG, 4, new Position(width / 2, height / 2), frameRate * 2));
    }
}

class Help extends AbstractScene {
    Help() {
         super("Help", "game/help", "help", Extension.JPG);
         addEvent(COLORS.get("red"), new SwitchScene(GAME_ID));
         addAnimation(new TitleAnimation("Help Animation", "game/help", "title", Extension.PNG, 4, new Position(width / 2, height / 6), frameRate * 2));
    }
}