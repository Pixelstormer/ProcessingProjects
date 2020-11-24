class cell{
  PVector location;
  PVector bounds;
  float value;
  float drainPercent;
  float minDrain;
  boolean drains;
  
  float fillAmt;
  boolean fills;
  
  cell(PVector location, PVector bounds, float value, float drainPercent, float minDrain, boolean drains, float fillAmt, boolean fills){
    this.location = location.get();
    this.bounds = bounds.get();
    this.value = value;
    this.drainPercent = drainPercent;
    this.minDrain = minDrain;
    this.drains = drains;
    this.fillAmt = fillAmt;
    this.fills = fills;
  }
  
  public void render(){
    stroke(122);
    strokeWeight(4);
    fill(0,0,map(this.value,0,1000,0,255));
    rect(this.location.x,this.location.y,this.bounds.x,this.bounds.y);
    fill(122);
    noStroke();
    textSize(this.bounds.x/5);
    text(nfc(this.value,2),this.location.x,this.location.y);
  }
  
  public float getFluid(){
    return this.value;
  }
  
  public float flow(){
    float flow = this.value / (100/this.drainPercent) / globalViscocity + globalViscocity;
    return flow;
  }
  
  public void drain(){
    this.value -= (this.drains) ? (this.value<=0) ? this.value : this.value / (100/this.drainPercent) + this.minDrain : 0;
  }
  
  public void fillSelf(){
    this.value += (this.fills) ? this.fillAmt : 0;
  }
  
  public void Fill(float input){
    this.value += input;
  }
}

