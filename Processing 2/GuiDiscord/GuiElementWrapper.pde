final class GuiElementWrapper{
  private GuiCanvas canvas;
  private GuiElement element;
  
  private double originX;
  private double originY;
  private double elementWidth;
  private double elementHeight;
  private double centerX;
  private double centerY;
  private double halfWidth;
  private double halfHeight;
  
  public GuiElement(GuiElement element, double originX, double originY, double elementWidth, double elementHeight){
    this.element = element;
    this.originX = originX;
    this.originY = originY;
    this.elementWidth = elementWidth;
    this.elementHeight = elementHeight;
    halfWidth = elementWidth/2;
    halfHeight = elementHeight/2;
    centerX = originX + halfWidth;
    centerY = originY + halfHeight;
  }
  
  public boolean pointIntersects(double x, double y){
    return pointIntersectsRectangle(originX, originY, elementWidth, elementHeight, x, y);
  }
  
  public void render(){
    element.render(originX, originY, elementWidth, elementHeight);
  }
  
  public void onUpdate(){
    element.onUpdate();
  }
  
  public void onMousePressed(double x, double y, int button){
    element.onMousePressed(x, y, button);
  }
  
  public void onMouseReleased(double x, double y, int button){
    element.onMouseReleased(x, y, button);
  }
  
  public void onMouseScroll(double x, double y, MouseEvent event){
    element.onMouseScroll(x, y, event);
  }
  
  public void onMouseStill(double x, double y){
    element.onMouseStill(x, y);
  }
  
  public void onMouseMoved(double oldX, double oldY, double newX, double newY){
    element.onMouseMoved(oldX, oldY, newX, newY);
  }
  
  public void onMouseDragged(double oldX, double oldY, double newX, double newY){
    element.onMouseDragged(oldX, oldY, newX, newY);
  }
  
  public void onKeyPressed(int key, int keyCode){
    element.onKeyPressed(key, keyCode);
  }
  
  public void onKeyReleased(int key, int keyCode){
    element.onKeyReleased(key, keyCode);
  }
}

