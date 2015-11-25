class Game extends AbstractScene {
    List<Scene> rooms;
    int activeRoom;
    Flashcard flashcard;
    Map<Color, FlashcardData> activeFlashcardDataMap;
    Window bottomMenu;
    Language language;
    Map<UUID, FlashcardData> room1Data, room2Data, room3Data;
    boolean createNewGame;
    boolean showFlashcard;
      
    Game() {
        name = "Game";
        createNewGame = true;
        showFlashcard = false;
    }
      
    void loadForInteraction() {
      if (!isLoaded) {
          println("loading game");
          Scene room1 = new Scene("Forest", "game/room1", "forest", Extension.JPG);
          Scene room2 = new Scene("Beach", "game/room2", "beach", Extension.JPG);
          Scene room3 = new Scene("Bedroom", "game/room3", "bedroom", Extension.JPG);
          
          room1Data = parseFlashcardData("room1", room1);
          room2Data = parseFlashcardData("room2", room2);
          room3Data = parseFlashcardData("room3", room3);
          
          rooms = new ArrayList<Scene>(3);
          rooms.add(room1);
          rooms.add(room2);
          rooms.add(room3);
          
          activeRoom = 0;
          activeFlashcardDataMap = rooms.get(activeRoom).getFlashcardDataMap();           
          
          language = Language.SPANISH;
          flashcard = new Flashcard(language);
          
          bottomMenu = new Frame("Bottom Menu", new Position(width / 2, height - 50),
              "game", "bottom_menu", Extension.JPG);
              
          isLoaded = true;
      }
    }
    
    void clickEvent(float x, float y) {
          if (showFlashcard && flashcard.isInFrame(x, y)) {
              showFlashcard = !flashcard.getClickColor(x, y).equals(COLORS.get("red"));            
          } else {
              if (bottomMenu.isInFrame(x, y)) {
                  Color clickColor = bottomMenu.getClickColor(x, y);
                  if (clickColor.equals(COLORS.get("red"))) {
                       new SwitchScene(MAIN_MENU_ID).execute(this);
                  } else if (clickColor.equals(COLORS.get("blue"))) {
                       new SwitchScene(HELP_ID).execute(this);
                  }
              } else {
                  Color clickColor = rooms.get(activeRoom).getClickColor(x, y);
                  if (clickColor.equals(COLORS.get("dark_purple"))) {
                      activeRoom = activeRoom >= rooms.size() - 1 ? 0 : activeRoom + 1;
                      activeFlashcardDataMap = rooms.get(activeRoom).getFlashcardDataMap();
                  } else if (clickColor.equals(COLORS.get("brown"))) {
                      activeRoom = activeRoom <= 0 ? rooms.size() - 1 : activeRoom - 1;
                      activeFlashcardDataMap = rooms.get(activeRoom).getFlashcardDataMap();
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
        if (showFlashcard) {
            if (flashcard.safeToClose()) {
                showFlashcard = false; 
            } else {
                noStroke();
                fill(0, 0, 0, 127);
                rect(0, 0, 1200, 700);
                noFill();
                flashcard.render();
            }
        }
    }
    
    void keyEvent(char k, int kCode) {
          if (showFlashcard) {
              flashcard.keyEvent(k, kCode);
          }
     }
     
     Map<UUID, FlashcardData> parseFlashcardData(String filename, Scene room) {
         Map<UUID, FlashcardData> data = new HashMap<UUID, FlashcardData>();
         Table dataTable = loadTable(String.format("csv/%s.csv", filename), "header");
         FlashcardData flashcardData;
         UUID uuid;
         for (TableRow row : dataTable.rows()) {
             uuid = UUID.fromString(row.getString("UUID"));
             flashcardData = new FlashcardData(uuid, row.getString("Word"));
             flashcardData.addTranslations("Spanish", row);
             data.put(uuid, flashcardData);
             room.addFlashcardData(COLORS.get(row.getString("Color")), flashcardData);
         }
         return data;
     }
    
  
}