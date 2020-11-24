interface IUpdateable{
  void update();
}

interface IRenderable{
  void render(double x, double y, double elementWidth, double elementHeight);
}

interface IClickable{
  void onMousePressed(double cursorX, double cursorY, int button);
  void onMouseReleased(double cursorX, double cursorY, int button);
}

interface IScrollable{
  public void onMouseScroll(double x, double yMouseEvent event);
}

interface IHoverable{
  void onMouseStill(double cursorX, double cursorY);
  void onMouseMoved(double oldX, double oldY, double newX, double newY);
  void onMouseDragged(double oldX, double oldY, double newX, double newY);
}

interface ITypable{
  void onKeyPressed(int key, int keyCode);
  void onKeyReleased(int key, int keyCode);
}

