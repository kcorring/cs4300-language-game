interface Event {
    void execute(Window window);
}

class SwitchScene implements Event {
    Integer windowID;
    Direction direction;
    
    SwitchScene(Integer windowID) {
        this.windowID = windowID;
    }
    
    SwitchScene(Integer windowID, Direction direction) {
        this.windowID = windowID;
        this.direction = direction;
    }
    
    void execute(Window window) {
        ((AbstractScene) window).surrenderControl();
        AbstractScene w = scenes.get(windowID);
        w.takeControl();
        if (direction != null) {
            w.receiveMessage(direction.name());
        }
    }
}

class PassMessage implements Event {
    String eventMsg;
  
     PassMessage(String eventMsg) {
         this.eventMsg = eventMsg; 
     }
      
     void execute(Window window) {
         window.receiveMessage(eventMsg);
     }
}