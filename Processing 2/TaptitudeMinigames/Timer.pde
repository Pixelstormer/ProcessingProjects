public class Timer{
  private float interval;
  private float tracker;
  
  public Timer(){
    this.interval = 1000;
    this.tracker = 0;
  }
  
  public Timer(float i, boolean field){
    this.interval = (field) ? i : 1000;
    this.tracker = (!field) ? i : 0;
  }
  
  public Timer(float i, float t){
    this.interval = i;
    this.tracker = t;
  }
  
  public float getInterval(){
    return this.interval;
  }
  
  public float getTracker(){
    return this.tracker;
  }
  
  public void setInterval(float i){
    this.interval = i;
  }
  
  public void setTracker(float t){
    this.tracker = t;
  }
  
  public boolean pollStateDiscreet(){
    return millis()-this.tracker >= this.interval;
  }
  
  public boolean pollStateIntrusive(){
    if(millis()-this.tracker >= this.interval){
      this.resetState();
      return true;
    }
    return false;
  }
  
  public boolean pollStateDisruptive(){
    boolean state = millis()-this.tracker >= this.interval;
    this.resetState();
    return state;
  }
  
  public void tickUpdate(){
    if(millis()-this.tracker >= this.interval){
      this.resetState();
    }
  }
  
  public void forceResetState(){
    this.resetState();
  }
  
  private void resetState(){
    this.tracker = millis();
  }
}


