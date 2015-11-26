// An AbstractFrame is a rectangular screen that appears on the scene and is able to be interacted with
abstract class Window implements Interactive {
    boolean isLoaded;
    String name;
    String imgLocation;
    String cmapLocation;
    
    PImage background;
    PImage colorMap;
    int w, h;
    
    HashMap<Color, Event> eventMap;
    List<Renderable> animations;
    
    boolean forceFocus;
    boolean active;
    boolean defaultWindow;
    
    Window() {
    }
    
    Window(String name, String imgFolder, String imgFilename, Extension imgExt) {
        this.name = name;
        imgLocation = String.format("%s/%s_img%s", imgFolder, imgFilename, imgExt);
        cmapLocation = String.format("%s/%s_cmap%s", imgFolder, imgFilename, imgExt);
        animations = new ArrayList<Renderable>();
        eventMap = new HashMap<Color, Event>();
        isLoaded = false;
    }
    
    void loadForInteraction() {
        if (!isLoaded) {
            background = loadImage(imgLocation);
            colorMap = loadImage(cmapLocation);
            
            w = background.width;
            h = background.height;
            
            colorMap.loadPixels();
            forceFocus = false;
            active = true;
            defaultWindow = false;
            
            isLoaded = true;
        }
    }
    
    boolean isLoaded() {
        return isLoaded; 
    }
    
    void setForceFocus(boolean forceFocus) {
        this.forceFocus = forceFocus; 
    }
    
    boolean getForceFocus() {
        return forceFocus; 
    }
    
    void setDefaultWindow(boolean defaultWindow) {
        this.defaultWindow = defaultWindow; 
    }
    
    void addEvent(Color c, Event e) {
        eventMap.put(c, e); 
    }
    
    void setEventMap(HashMap<Color, Event> eventMap) {
        this.eventMap = eventMap;
    }
    
    void addAnimation(Renderable animation) {
        animations.add(animation); 
    }
    
    void render() {
        image(background, 0, 0);
        for (Renderable a : animations) {
            a.render();
        }    
    }
    
    boolean isInFrame(float x, float y) {
        return true;
    }
    
    Color getClickColor(float x, float y) {
        Color tmp = new Color(colorMap.pixels[int(x) + int(y) * w]);
        //println(String.format("%s:\t%s", this, tmp));
        return tmp;
    }
    
    // handles a click event
    void clickEvent(float x, float y) {
        Color clickColor = getClickColor(x, y);
        for (Color c : eventMap.keySet()) {
            if (c.equals(clickColor)) {
                eventMap.get(c).execute(this);
            }
        }
    }
    
    void keyEvent(char k, int kCode) {
         //println(k);
         //println(kCode);
         //println(k == CODED);
    }
    
    void closeWindow() {
        active = false;
    }
    
    void receiveMessage(String eventMsg) {
        
    }
    
    @Override
    public String toString() {
        return name; 
    }
}