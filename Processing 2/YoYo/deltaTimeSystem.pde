class deltaTimeSystem{
  private float lastMillis = 0;
  public float deltaTime = 0;
  public float scaledDeltaTime = 0;
  private float SCALAR = 1000;
  
  public deltaTimeSystem(){
    init();
  }
  
  private void init(){
    setScalar(1000);
    update();
  }
  
  public void update(){
    deltaTime = millis() - lastMillis;
    scaledDeltaTime = deltaTime / SCALAR;
    lastMillis = millis();
  }
  
  public void setScalar(float Scalar){
    SCALAR = Scalar;
  }
}


