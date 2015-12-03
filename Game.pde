class Game extends AbstractScene {
    private static final int SCORE_OFFSET = 325;
    List<Scene> rooms;
    int activeRoom;
    Flashcard flashcard;
    Window bottomMenu, areYouSure, youWin;
    GameData gameData;
    Map<Color, FlashcardData> activeFlashcardDataMap;
    boolean createNewGame;
    boolean showFlashcard, showAreYouSure, showYouWin;
    boolean gameDone;
      
    Game() {
        name = "Game";
        createNewGame = true;
        showFlashcard = false;
    }
      
    void loadForInteraction() {
      if (!isLoaded) {
          //println("loading game");
          Scene room1 = new Scene("1", "game/room1", "forest", Extension.JPG);
          Scene room2 = new Scene("2", "game/room2", "beach", Extension.JPG);
          Scene room3 = new Scene("3", "game/room3", "bedroom", Extension.JPG);
          
          rooms = new ArrayList<Scene>(3);
          rooms.add(room1);
          rooms.add(room2);
          rooms.add(room3);
          
          activeRoom = 0;
          activeFlashcardDataMap = gameData.getFlashcardDataMap(rooms.get(activeRoom).getRoomID());           
          
          flashcard = new Flashcard(gameData.language);
          
          areYouSure = new Frame("Are You Sure", new Position(width / 2, height / 2),
              "game", "are_you_sure", Extension.JPG);
          
          youWin = new Frame("You Win", new Position(width / 2, height / 2),
              "game", "you_win", Extension.JPG);
          
          bottomMenu = new Frame("Bottom Menu", new Position(width / 2, height - 50),
              "game", "bottom_menu", Extension.JPG);
              
          isLoaded = true;
          //println(gameData.score);
      }
    }
    
    void setGameData(GameData gameData) {
        this.gameData = gameData;
        flashcard = new Flashcard(gameData.language);
        activeRoom = 0;
        try {
            activeFlashcardDataMap = gameData.getFlashcardDataMap(rooms.get(activeRoom).getRoomID());    
        } catch (Exception e) {
          
        }
    }
    
    void clickEvent(float x, float y) {
          if (showFlashcard && flashcard.isInFrame(x, y)) {
              showFlashcard = !flashcard.getClickColor(x, y).equals(COLORS.get("red"));
              if (!gameDone) {
                  checkGameOver();
              }
          } else if (showAreYouSure && areYouSure.isInFrame(x,y)) {
              Color clickColor = areYouSure.getClickColor(x, y);
              if (clickColor.equals(COLORS.get("red"))) {
                  showAreYouSure = false;
                  new SwitchScene(MAIN_MENU_ID).execute(this);
              } else if (clickColor.equals(COLORS.get("blue"))) {
                  showAreYouSure = false; 
              }
          } else if (showYouWin && youWin.isInFrame(x, y)) {
              Color clickColor = youWin.getClickColor(x, y);
              if (clickColor.equals(COLORS.get("red"))) {
                  showYouWin = false;
                  new SwitchScene(MAIN_MENU_ID).execute(this);
              } else if (clickColor.equals(COLORS.get("blue"))) {
                  showYouWin = false; 
              }
          } else {
              if (bottomMenu.isInFrame(x, y)) {
                  Color clickColor = bottomMenu.getClickColor(x, y);
                  if (clickColor.equals(COLORS.get("red"))) {
                       showAreYouSure = true;
                  } else if (clickColor.equals(COLORS.get("blue"))) {
                       new SwitchScene(HELP_ID).execute(this);
                  }
              } else {
                  Color clickColor = rooms.get(activeRoom).getClickColor(x, y);
                  if (clickColor.equals(COLORS.get("dark_purple"))) {
                      activeRoom = activeRoom >= rooms.size() - 1 ? 0 : activeRoom + 1;
                      activeFlashcardDataMap = gameData.getFlashcardDataMap(rooms.get(activeRoom).getRoomID());
                  } else if (clickColor.equals(COLORS.get("brown"))) {
                      activeRoom = activeRoom <= 0 ? rooms.size() - 1 : activeRoom - 1;
                      activeFlashcardDataMap = gameData.getFlashcardDataMap(rooms.get(activeRoom).getRoomID());
                  } else {
                      for (Color c : activeFlashcardDataMap.keySet()) {
                          if (c.equals(clickColor)) {
                              showFlashcard = true;
                              flashcard.addData(activeFlashcardDataMap.get(c));
                              break;
                          }
                      }
                  }
              }
          }
    }
    
    void render() {
        rooms.get(activeRoom).render();
        bottomMenu.render();
        renderScore();
        if (showAreYouSure || showFlashcard || showYouWin) {
            noStroke();
            fill(0, 0, 0, 127);
            rect(0, 0, 1200, 700);
            noFill();
            if (showAreYouSure) {
                areYouSure.render();
            } else if (showFlashcard) {
                flashcard.render(); 
            } else {
                youWin.render(); 
            }
        }
    }
    
    void renderScore() {
       textFont(wordFont, 80);
       fill(0);
       textAlign(CENTER);
       text(str(gameData.score), width / 2, height / 2 + SCORE_OFFSET);
    }
    
    void keyEvent(char k, int kCode) {
          if (showFlashcard) {
              flashcard.keyEvent(k, kCode);
          }
     }
    
  
     void updateFlashcard(UUID id, boolean correct) {
         gameData.updateFlashcard(id, correct);
         //println(gameData.score);
     }
     
     void checkGameOver() {
         showYouWin = gameData.checkGameOver();
         gameDone = showYouWin;
     }
}