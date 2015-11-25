import java.util.Map;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;
import java.util.UUID;
import java.util.Date;
import java.util.Iterator;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
private static final int FRAME_RATE = 60;
private static final int EQUAL_COLOR_DIST = 20;
PFont wordFont;

//Flashcard flashcard;
Map<String, Color> COLORS;
private static final int MAIN_MENU_ID = 0;
private static final int SCORES_ID    = 1;
private static final int CREDITS_ID   = 2;
private static final int GAME_TYPE_ID = 3;
private static final int NEW_GAME_ID  = 4;
private static final int LOAD_GAME_ID = 5;
private static final int GAME_ID      = 6;
private static final int HELP_ID      = 7;
Map<Integer, AbstractScene> scenes;
AbstractScene currentScene;

void setup() {
    size(1200, 700);
    smooth();
    frameRate(FRAME_RATE);
    
    COLORS = new HashMap<String, Color>();
    Table colorData = loadTable("csv/colors.csv", "header");
    for (TableRow row : colorData.rows()) {
        COLORS.put(row.getString("Color"), new Color(row.getInt("Red"), row.getInt("Green"), row.getInt("Blue"))); 
    }
    wordFont = createFont("appleberry", 16, true);
    
    scenes = new HashMap<Integer, AbstractScene>();
    
    Event switchGameType = new SwitchScene(GAME_TYPE_ID);
    Event switchGame = new SwitchScene(GAME_ID);
    
    AbstractScene mainMenu = new MainMenu();
    AbstractScene credits = new Credits();
    AbstractScene scores = new Scores();
    AbstractScene gameType = new GameType();
    AbstractScene loadGame = new LoadGame();
    AbstractScene newGame = new NewGame();
    AbstractScene help = new Help();
    AbstractScene game = new Game();
    
    scenes.put(MAIN_MENU_ID, mainMenu);
    scenes.put(SCORES_ID, scores);
    scenes.put(CREDITS_ID, credits);
    scenes.put(GAME_TYPE_ID, gameType);
    scenes.put(LOAD_GAME_ID, loadGame);
    scenes.put(NEW_GAME_ID, newGame);
    scenes.put(GAME_ID, game);
    scenes.put(HELP_ID, help);
    
    mainMenu.takeControl();
}

void draw() {
    currentScene.render();
}

void mouseClicked() {
    currentScene.clickEvent(mouseX, mouseY);
}

void keyPressed() {
    currentScene.keyEvent(key, keyCode);
}