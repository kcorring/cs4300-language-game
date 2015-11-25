private static final int WORD_OFFSET = -40;
private static final int INPUT_OFFSET = 100;

class Flashcard extends AbstractFrame {
   Language language;
   FlashcardData data;
   String userInput;
   boolean answer;
   boolean isHandlingAnswer;
   PImage regBackground, regColorMap;
   PImage wideBackground, wideColorMap;
   Position regOffset, wideOffset;
   int rW, rH, wW, wH;
   boolean isWide;
   Animation answerAnimation;
    
   Flashcard(Language language) {
       super("Flashcard", new Position(width / 2, height / 2), "game", "flashcard", Extension.JPG);
       regBackground = background;
       regColorMap = colorMap;
       regOffset = offset;
       rW = w;
       rH = h;
        
       wideBackground = loadImage("game/flashcard_wide_img.jpg");
       wideColorMap = loadImage("game/flashcard_wide_cmap.jpg");
       wW = wideBackground.width;
       wH = wideBackground.height;
       wideOffset = new Position((width - wW) / 2, (height - wH) / 2);
        
       isWide = false;
        
       forceFocus = true;
       userInput = "";
       this.language = language;
   }
    
   void addData(FlashcardData data) {
       this.data = data; 
       userInput = "";
        
       float stringLength = max(textWidth(data.word), data.longestTranslation);
       if (stringLength > rW - 50 && !isWide) {
           changeFlashcardSize(wideBackground, wideColorMap, wW, wH, wideOffset, true);
       } else if (stringLength <= rW - 50 && isWide) {
           changeFlashcardSize(regBackground, regColorMap, rW, rH, regOffset, false);
       }
       answer = false;
   }
   
   boolean safeToClose() {
       return answer && answerAnimation == null;
   }
    
   void render() {
       textFont(wordFont, 80);
       fill(0);
       textAlign(CENTER);
       super.render();
        
       text(data.word, width / 2, height / 2 + WORD_OFFSET);
       if (answerAnimation != null) {
           if (answerAnimation.isDone()) {
               answerAnimation = null;
               if (answer) {
                   closeWindow();
               } else {
                   text(userInput, width / 2, height / 2 + INPUT_OFFSET);
               }
           } else {
               answerAnimation.render();
           }
       } else {
           text(userInput, width / 2, height / 2 + INPUT_OFFSET);
       }
       noFill();
   }
    
   void changeFlashcardSize(PImage background, PImage colorMap, int w, int h, Position offset, boolean isWide) {
       this.background = background;
       this.colorMap = colorMap;
       this.w = w;
       this.h = h;
       this.offset = offset;
       this.isWide = isWide;
   }
    
   void keyEvent(char k, int kCode) {
       if (k != CODED && !isHandlingAnswer) {
           if (k == ENTER || k == RETURN) {
               answer = data.checkAnswer(userInput,language);
               if (answer) {
                   updateScore(); 
               }
               answerAnimation = new AnswerAnimation(userInput, answer, 80);
           } else if (k == BACKSPACE || k == DELETE) {
               int len = userInput.length();
               if (len > 0) {
                   userInput = userInput.substring(0, userInput.length() - 1);
               }
           } else if (k == TAB || k == ESC) {
               // maybe try to catch escape key and exit flashcard
           } else {
               String tmp = userInput + k;
               if (textWidth(tmp) > wW - 50 ||
                   (textWidth(tmp) > rW - 50 && !isWide)) {
               } else {
                   userInput += k;
               }
           }
       }
   }
    
   void clickEvent(float x, float y) {
       if (answerAnimation == null) {
           super.clickEvent(x, y);
       }
   }
    
   void updateScore() {
      
   }
}