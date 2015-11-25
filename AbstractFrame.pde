// An Frame is a rectangular pop-up screen that appears on the scene and is able to be interacted with
abstract class AbstractFrame extends Window {
    Position posn; // center of the frame
    Position offset; // top left corner of the frame
    
    AbstractFrame(String name, Position posn, String imgFolder, String imgFilename, Extension imgExt) {
        super(name, imgFolder, imgFilename, imgExt);
        loadForInteraction();
        this.posn = posn;
        w = background.width;
        h = background.height;
        offset = new Position(posn.x - w / 2, posn.y - h / 2);
    }
    
    void render() {
        image(background, offset.x, offset.y);
    }
    
    boolean isInFrame(float x, float y) {
        return x >= offset.x &&
            x <= offset.x + w &&
            y >= offset.y &&
            y <= offset.y + h;
    }
    
    Color getClickColor(float x, float y) {
        return super.getClickColor(x - offset.x, y - offset.y);
    }
    
    // handles a click event
    void clickEvent(float x, float y) {
        if (isInFrame(x, y)) {
            super.clickEvent(x - offset.x, y - offset.y);
        }
    }
}

class Frame extends AbstractFrame {
    Frame(String name, Position posn, String imgFolder, String imgFilename, Extension imgExt) {
        super(name, posn, imgFolder, imgFilename, imgExt);
    }
}