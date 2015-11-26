class GameType extends AbstractScene {
    boolean canLoadGames;
    Direction direction;
    SwitchScene newGame = new SwitchScene(NEW_GAME_ID);
    SwitchScene mainMenu = new SwitchScene(MAIN_MENU_ID);
    
    GameType() {
        super("Game Type", "main_menu/game_type", "game_type", Extension.JPG);
        addEvent(COLORS.get("red"), newGame);
        addEvent(COLORS.get("green"), mainMenu);
        addEvent(COLORS.get("blue"), new SwitchScene(LOAD_GAME_ID));
        direction = Direction.NEXT;
    }
    
    void loadForInteraction() {
        super.loadForInteraction();
        // TODO: read from CSV to check if games in progress
        canLoadGames = false;
    }
    
    void render() {
        if (canLoadGames) {
            super.render(); 
        } else {
            if (direction == Direction.BACK) {
                mainMenu.execute(this);
            } else {
                newGame.execute(this);
            }
        }
    }
    
    void receiveMessage(String message) {
        try {
            direction = Direction.valueOf(message);
        } catch (Exception e) {
            println(String.format("%s received non-direction message: %s", this, message));
        }
    }
}

class LoadGame extends AbstractScene {
    LoadGame() {
         super("Load Game", "main_menu/game_type", "load_game", Extension.JPG);
         addEvent(COLORS.get("red"), new SwitchScene(GAME_TYPE_ID, Direction.BACK));
         addAnimation(new TitleAnimation("Load Game Animation", "main_menu/game_type", "title", Extension.PNG, 4, new Position(width / 2, height / 2), frameRate * 2));
    }
}

class NewGame extends AbstractScene {
    private final float OFFSET_X = -175;
    private final float OFFSET_Y = -55;
    private final int MAX_NAME_WIDTH = 507;
    private final Color NEW_GAME_COLOR = COLORS.get("yellow");
    boolean isPlayable;
    PImage playBackground, playColorMap;
    PImage nonPlayBackground, nonPlayColorMap;
    PImage enterNameBackground;
    List<String> languages;
    Map<String, PImage> languageRenders;
    int langPointer;
    String currentLang;
    String userInput;
    
    
    NewGame() {
        super("New Game", "main_menu/game_type", "new_game_play", Extension.JPG);
        addEvent(COLORS.get("red"), new PassMessage("RIGHT"));
        addEvent(COLORS.get("blue"), new PassMessage("LEFT"));
        addEvent(COLORS.get("green"), new SwitchScene(GAME_TYPE_ID, Direction.BACK));
        addEvent(NEW_GAME_COLOR, new SwitchScene(GAME_ID));
    }
    
    void loadForInteraction() {
        if (!isLoaded) {
            super.loadForInteraction();
            playBackground = background;
            playColorMap = colorMap;
            
            nonPlayBackground = loadImage("main_menu/game_type/new_game_img.jpg");
            nonPlayColorMap = loadImage("main_menu/game_type/new_game_cmap.jpg");
            enterNameBackground = loadImage("main_menu/game_type/new_game_name_img.jpg");
            
            // TODO: DON'T HARDCODE THESE
            languages = new ArrayList<String>(3);
            languages.add("spanish");
            languages.add("italian");
            languages.add("french");
            langPointer = 0;
            currentLang = languages.get(langPointer);
            languageRenders = new HashMap<String, PImage>();
            for (String l : languages) {
                languageRenders.put(l, loadImage(String.format("main_menu/game_type/%s%s", l, Extension.PNG))); 
            }
            userInput = "";
            isPlayable = true;
        }
    }
    
    void receiveMessage(String message) {
        if (message.equals("LEFT")) {
            langPointer = langPointer <= 0 ? languages.size() - 1 : langPointer - 1; 
        } else if (message.equals("RIGHT")) {
            langPointer = langPointer >= languages.size() - 1 ? 0 : langPointer + 1; 
        }
        currentLang = languages.get(langPointer);
    }
    
    void render() {
        boolean hasLang = languages.contains(currentLang);
        boolean hasInput = userInput.trim().length() > 0;
        if (!hasLang || !hasInput) {
            if (isPlayable) {
                switchPlayable(false, !hasLang ? nonPlayBackground : enterNameBackground, nonPlayColorMap);
            } else {
                background = !hasLang ? nonPlayBackground : enterNameBackground;
            }
        } else if (!isPlayable) {
            switchPlayable(true, playBackground, playColorMap);
        }
        super.render();
        image(languageRenders.get(currentLang), 0, 0);
        
        textFont(wordFont, 80);
        fill(0);
        textAlign(LEFT);
        text(userInput, width / 2 + OFFSET_X, height / 2 + OFFSET_Y);
    }
    
    void surrenderControl() {
        userInput = "";
        langPointer = 0;
        currentLang = languages.get(langPointer);
        switchPlayable(true, playBackground, playColorMap);
    }
    
    void switchPlayable(boolean isPlayable, PImage toBackground, PImage toColorMap) {
        this.isPlayable = isPlayable; 
        background = toBackground;
        colorMap = toColorMap;
    }
   
    void keyEvent(char k, int kCode) {
       if (k != CODED) {
           if (k == BACKSPACE || k == DELETE) {
               int len = userInput.length();
               if (len > 0) {
                   userInput = userInput.substring(0, userInput.length() - 1);
               }
           } else if (k != ENTER && k != RETURN && k != TAB && k != ESC) {
               String tmp = userInput + k;
               if (textWidth(tmp) <= MAX_NAME_WIDTH) {
                   userInput += k;
               }
           }
       }
    }
   
    // handles a click event
    void clickEvent(float x, float y) {
        Color clickColor = getClickColor(x, y);
        if (clickColor.equals(NEW_GAME_COLOR)) {
           getGame().setGameData(new GameData(userInput.trim(), Language.valueOf(currentLang.toUpperCase())));
           new SwitchScene(GAME_ID).execute(this);
        } else {
            for (Color c : eventMap.keySet()) {
                if (c.equals(clickColor)) {
                    eventMap.get(c).execute(this);
                }
            }
        }
    }
}