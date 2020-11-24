class GuiElement{
  public void update         (){}
  public void render         (double x, double y, double elementWidth, double elementHeight){}
  public void onMousePressed      (double cursorX, double cursorY, int button){}
  public void onMouseReleased     (double cursorX, double cursorY, int button){}
  public void onMouseScroll  (double x, double yMouseEvent event){}
  public void onMouseStill   (double cursorX, double cursorY){}
  public void onMouseMoved   (double oldX, double oldY, double newX, double newY){}
  public void onMouseDragged (double oldX, double oldY, double newX, double newY){}
  public void onKeyPress     (int key, int keyCode){}
  public void onKeyRelease   (int key, int keyCode){}
}

