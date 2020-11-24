class Camera{
  private final PGraphics renderSurface;
  private final float minimumScalar;
  private PVector translation;
  private PVector scaleCenter;
  private float scalar;
  private boolean inDrawableState;
  
  Camera(int width, int height, float minScalar, PVector scaleCenter){
    minimumScalar = minScalar;
    renderSurface = createGraphics(width, height);
    translation = new PVector(0, 0);
    scalar = 0;
    inDrawableState = false;
    this.scaleCenter = scaleCenter.get();
  }
  
  Camera(int width, int height, float minScalar){
    this(width, height, minScalar, new PVector(0, 0));
  }
  
  PGraphics getRenderSurface(){
    return renderSurface;
  }
  
  PVector getTranslation(){
    return translation.get();
  }
  
  PVector getScaleCenter(){
    return scaleCenter.get();
  }
  
  float getScalar(){
    return scalar;
  }
  
  boolean isInDrawableState(){
    return inDrawableState;
  }
  
  void addTranslation(PVector by){
    translation.add(by);
  }
  
  void setTranslation(PVector to){
    translation.set(to.x, to.y);
  }
  
  void addScale(float amt){
    scalar += amt;
    if(scalar < minimumScalar)
      scalar = minimumScalar;
  }
  
  void setScale(float to){
    scalar = max(to, minimumScalar);
  }
  
  void offsetScaleCenter(PVector by){
    scaleCenter.add(by);
  }
  
  void setScaleCenter(PVector to){
    scaleCenter.set(to.x, to.y);
  }
  
  void beginDraw(){
    if(inDrawableState)
      throw new IllegalStateException("Cannot begin draw when drawing has already been begun.");
    renderSurface.beginDraw();
    inDrawableState = true;
  }
  
  void endDraw(){
    if(!inDrawableState)
      throw new IllegalStateException("Cannot end draw when drawing has not been begun.");
    renderSurface.endDraw();
    inDrawableState = false;
  }
  
  void drawSurface(){
    translate(scaleCenter.x, scaleCenter.y);
    scale(scalar);
    image(renderSurface, -translation.x, -translation.y);
  }
}

