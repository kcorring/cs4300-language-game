class TitleAnimation implements Renderable {
    String name;
    Position posn;
    float rate;
    List<PImage> titleFrames;

    TitleAnimation(String name, String imgFolder, String imgTitle, Extension imgExt, int count, Position posn, float rate) {
        this.name = name;
        this.rate = rate;
        titleFrames = new ArrayList<PImage>();
        for (int i = 0; i < count; i++) {
            titleFrames.add(loadImage(String.format("%s/%s_%d%s", imgFolder, imgTitle, i, imgExt)));
        }
        
        PImage sampleFrame = titleFrames.get(0);
        this.posn = new Position(posn.x - sampleFrame.width / 2, posn.y - sampleFrame.height / 2);
    }
    
    void render() {
        image(titleFrames.get(int(frameCount / rate) % titleFrames.size()), posn.x, posn.y);
    }
    
    boolean isDone() {
        return false;
    }
}

class AnswerAnimation implements Animation {
   String userInput;
   int size;
   int minSize;
   int maxSize;
   boolean isGrow;
   int cycles = 3;
   Color c;
    
   AnswerAnimation(String userInput, boolean isCorrect, int startSize) {
       this.userInput = userInput;
       this.size = startSize;
       minSize = size;
       maxSize = size + 10;
       isGrow = true;
       c = isCorrect ? new Color(0, 255, 0) : new Color(255, 0, 0);
   }
    
   void render() {
       if (size < maxSize && isGrow) {
          size++; 
       } else if (size == maxSize) {
          size--;
          isGrow = false;
       } else if (size > minSize) {
          size--; 
       } else {
          isGrow = true;
          cycles--;
       }
       textFont(wordFont, size);
       fill(c.r, c.g, c.b);
       text(userInput, width / 2, height / 2 + INPUT_OFFSET);
   }
    
   boolean isDone() {
       return cycles <= 0; 
   }
}