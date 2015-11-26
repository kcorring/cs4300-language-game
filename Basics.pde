interface Renderable {
    // draws the scene
    void render();
}

interface Interactive extends Renderable {
    //boolean isLoaded();
    
    //void loadForInteraction();
    
    // handles a click event
    void clickEvent(float x, float y);
    
    // handles a key press
    void keyEvent(char k, int kCode);
}

interface Animation extends Renderable {
    boolean isDone();
}

class Position {
    float x, y;
    
    Position(float x, float y) {
        this.x = x;
        this.y = y;
    }
}

class Color {
    int r, g, b;
    float opacity;
  
    Color(int r, int g, int b) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.opacity = 255;
    }
  
    Color(int r, int g, int b, float opacity) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.opacity = opacity;
    }
    
    Color(color c) {
        this.r = int(red(c));
        this.g = int(green(c));
        this.b = int(blue(c));
        this.opacity = alpha(c);
    }
    
    Color(float opacity) {
        this.opacity = opacity;
    }
    
    @Override
    public String toString() {
        return String.format("Color(%d, %d, %d, %d)", r, g, b, int(opacity)); 
    }
    
    @Override
    public boolean equals(Object o) {
        if (o instanceof Color) {
            Color c = (Color) o;
            return abs(r - c.r) + abs(g - c.g) + abs(b - c.b) <= EQUAL_COLOR_DIST;
        }
        return false;
    }
}

enum Language {
    SPANISH, ITALIAN, FRENCH; 
}

enum Extension {
    JPG (".jpg"), PNG (".png");
    
    private final String ext;
    
    Extension(String ext) {
        this.ext = ext;
    }
    
    @Override
    public String toString() {
        return ext;
    }
}

enum Direction {
    BACK, NEXT;
}