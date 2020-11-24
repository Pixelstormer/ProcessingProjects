class Camera{
  //Scene this camera is rendering
  private PGraphics scene;
  //Offset by which the scene will be rendered
  private PVector offset;
  //Scale factor for rendering the scene
  private float scale;
  //Has scene.endDraw() not been called yet, after a call to scene.beginDraw()?
  private boolean isDrawing;
  
  Camera(){
    this(width,height,1);
  }
  
  //Width and height are measured in pixels
  Camera(int width, int height){
    this(width,height,1);
  }
  
  Camera(int width, int height, float scale){
    scene = createGraphics(width, height);
    offset = new PVector(0,0);
    this.scale = scale;
    isDrawing = false;
  }
  
  PGraphics scene(){
    return scene;
  }
  
  PVector getOffset(){
    return offset.get();
  }
  
  PVector offset(){
    return offset;
  }
  
  float getScale(){
    return scale;
  }
  
  boolean setScale(float scale){
    this.scale = scale;
    return constrainScale(String.format("Caused by attempting to directly set scale to %s", scale));
  }
  
  boolean zoomIn(float offset){
    scale += offset;
    return constrainScale(String.format("Caused by attempting to increment scale by %s", offset));
  }
  
  boolean zoomOut(float offset){
    scale -= offset;
    return constrainScale(String.format("Caused by attempting to decrement scale by %s", offset));
  }
  
  boolean constrainScale(String note){
    if(scale<=0){
      System.err.println(String.format("WARNING! The scale factor of camera '%s' has been found to be an illegal amount: '%s'! This scale factor will be reset to the default of 1. (%s)", this, scale, note));
      scale = 1;
      return false;
    }
    return true;
  }
  
  boolean isDrawing(){
    return isDrawing;
  }
  
  boolean constrainScale(){
    return constrainScale("No note");
  }
  
  void beginDraw(){
    scene.beginDraw();
    isDrawing = true;
  }
  
  void endDraw(){
    scene.endDraw();
    isDrawing = false;
  }
}

