final class RoundButton extends GuiElement implements IUpdateable, IRenderable, IClickable{
  private final color fillColour;
  private final color outlineColour;
  private final color depressedColour;
  private final double lerpSpeed;
  
  private boolean depressed;
  private color activeColour;
  
  public RoundButton(double lerpSpeed, color fillColour, color outlineColour, color depressedColour){
    this.fillColour = fillColour;
    this.outlineColour = outlineColour;
    this.depressedColour = depressedColour;
    this.lerpSpeed = lerpSpeed;
    activeColour = fillColour;
    depressed = false;
  }
  
  @Override
  void update(){
    activeColour = lerpColor(activeColour, (depressed) ? depressedColour : fillColour, lerpSpeed);
  }
  
  @Override
  void onMousePressed(double cursorX, double cursorY, int button){
    if(pointIntersects(cursorX, cursorY)){
      depressed = true;
    }
  }
  
  @Override
  void onMouseReleased(double cursorX, double cursorY, int button){
    depressed = false;
  }
  
  @Override
  public void render(){
    fill(activeColour);
    stroke(outlineColour);
    strokeWeight(1);
    ellipseMode(CORNER);
    ellipse((float) originX, (float) originY, (float) elementWidth, (float) elementHeight);
  }
}

