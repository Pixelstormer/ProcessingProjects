class GuiNode extends Node {
  //Provides actual interactability

  //Expected behaviour:
  //Upon selecting a node a group of GuiNodes will emerge presenting various options
  //They can be clicked to perform actions instead of using hotkeys
  //They are highlighted when hovered over (w/ additional explanation?)
  //When node is deselected they retreat and disappear
  //They should be rendered over (and not collide with) other nodes

  //Functionality for this GuiNode
  private Method action;
  private Object context;

  //If this node should render
  private boolean isVisible;

  //Time in milliseconds until isVisible is flipped
  private float swapTimer;
  
  //Provides a brief description of this GuiNode's function
  private String hintText;

  //Node from which to render from
  private Node host;

  GuiNode(Method action, Object context, String hintText, PVector location, PVector renderLocation, float size, float actualSize, float outlineSize, float alignAngle, String text, PVector fill, PVector stroke, boolean ignoreParent, int childCount) {
    super(location, renderLocation, size, actualSize, outlineSize, alignAngle, text, fill, stroke, ignoreParent, childCount);
    this.action = action;
    this.context = context;
    this.setHintText(hintText);
    this.isVisible = false;
  }

  void setToAppearFrom(Node target) {
    this.setRenderLocation(target.location());
    this.setRenderSize(0);
    this.setSize(GUI_NODE_SIZE);

    this.host = target;

    this.setLocation(this.getHostOffset());
  }

  PVector getOffset() {
    if (this.host == null) return new PVector(0, 0);
    PVector angle = PVector.fromAngle(radians(this.getAngle()));
    angle.setMag(this.host.actualSize()/2 + this.actualSize()/2 + GUI_NODE_DISTANCE);
    return angle.get();
  }

  PVector getHostOffset() {
    if (this.host == null) return new PVector(0, 0);
    return PVector.add(this.getOffset(), this.host.location());
  }

  void setToDisappearInto(Node target) {
    this.setSize(0);
    this.setLocation(target.location());
    this.host = target;
  }

  void updateLocation() {
    if (this.swapTimer <= 0) this.setLocation(this.getHostOffset());
  }

  void setTimer(float time) {
    this.swapTimer = millis() + time;
  }

  void updateTimer() {
    if (this.swapTimer > 0 && millis() > this.swapTimer) {
      this.swapTimer = 0;
      this.toggleVisible();
    }
  }

  boolean isVisible() {
    return this.isVisible;
  }

  void toggleVisible() {
    this.isVisible = !this.isVisible;
  }

  void setVisible(boolean setTo) {
    this.isVisible = setTo;
  }
  
  void setHintText(String text){
    this.hintText = text;
  }
  
  String getHintText(){
    return this.hintText;
  }

  void invokeAction(Node subject) throws Exception {
    //It is up to the caller to deal with the consequences of
    //invoking the registered method, so exceptions are blindly re-thrown.

    if (!this.action.isAccessible()) this.action.setAccessible(true);
    try {
      this.action.invoke(this.context, this, subject);
    }
    catch(InvocationTargetException e) {
      println("Encountered an InvocationTargetException. The packaged exception will be thrown.");
      throw (Exception)e.getCause();
    }
    catch(IllegalAccessException e) {
      println("Encountered an IllegalAccessException while attempting to invoke:");
      println(String.format("  Action: %s\n  Context: %s\n  Subject: %s\n  Called from: %s", this.action, this.context, subject, this));
      e.printStackTrace();
    }
  }
}

