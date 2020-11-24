class GuiCanvas{
  private final List<GuiElementWrapper> elements;
  private color backgroundColour;
  
  public GuiCanvas(color colour){
    elements = new ArrayList<GuiElementWrapper>();
    backgroundColour = colour;
  }
  
  public GuiCanvas(){
    this(0);
  }
  
  public void onKeyPress(){
    for(GuiElement e : elements)
      if(e instanceof IKeyTracking)
        ((IKeyTracking) e).onKeyPress(key);
  }
  
  public void onKeyRelease(){
    for(GuiElement e : elements)
      if(e instanceof IKeyTracking)
        ((IKeyTracking) e).onKeyRelease(key);
  }
  
  public void onMousePress(){
    for(GuiElement e : elements)
      if(e instanceof IClickable)
        ((IClickable) e).onPressed(mouseX, mouseY, mouseButton);
  }
  
  public void onMouseRelease(){
    for(GuiElement e : elements)
      if(e instanceof IClickable)
        ((IClickable) e).onReleased(mouseX, mouseY, mouseButton);
  }
  
  public void onMouseMove(){
    for(GuiElement e : elements)
      if(e instanceof IMousePositionTracking)
        ((IMousePositionTracking) e).onMouseMoved(pmouseX, pmouseY, mouseX, mouseY);
  }
  
  public void onMouseDrag(){
    for(GuiElement e : elements)
      if(e instanceof IMousePositionTracking)
        ((IMousePositionTracking) e).onMouseDragged(pmouseX, pmouseY, mouseX, mouseY);
  }
  
  public void onMouseScroll(MouseEvent event){
    for(GuiElement e : elements)
      if(e instanceof IScrollable)
        ((IScrollable) e).onMouseScroll(event);
  }
  
  public boolean tryAddElement(GuiElement element){
    elements.add(element);
    return true;
  }
  
  public void guiUpdate(){
    for(GuiElement e : elements){
      if(e instanceof IUpdateable)
        ((IUpdateable) e).update();
      
      if(pmouseX == mouseX && pmouseY == mouseY)
        if(e instanceof IMousePositionTracking)
          ((IMousePositionTracking) e).onMouseStill(mouseX, mouseY);
    }
  }
  
  public void render(){
    background(backgroundColour);
    for(GuiElement e : elements)
      e.render();
  }
}

