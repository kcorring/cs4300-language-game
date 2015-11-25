// A Scene fills the entire screen
class AbstractScene extends Window {
  
    AbstractScene() {
    }
    
    AbstractScene(String name, String imgFolder, String imgFilename, Extension imgExt) {
        super(name, imgFolder, imgFilename, imgExt);
    }
    
    @Override
    public boolean equals(Object o) {
        if (o instanceof Scene) {
            Scene s = (Scene) o;
            return s.name == name;
        }
        return false;
    }
    
    void surrenderControl() {
      println(this + " surrendered");
    }
    
    void takeControl() {
        loadForInteraction();
        currentScene = this;
        println(this + " took control");
    }
}

class Scene extends AbstractScene {
    Map<Color, FlashcardData> flashcardDataMap;
    
    Scene(String name, String imgFolder, String imgFilename, Extension imgExt) {
        super(name, imgFolder, imgFilename, imgExt);
        loadForInteraction();
        flashcardDataMap = new HashMap<Color, FlashcardData>();
    }
    
    void addFlashcardData(Color c, FlashcardData flashcardData) {
        flashcardDataMap.put(c, flashcardData); 
    }
    
    Map<Color, FlashcardData> getFlashcardDataMap() {
        return flashcardDataMap; 
    }
    
    
}