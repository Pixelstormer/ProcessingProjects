class ant extends point{
  private int angle;
  
  ant(){
    this.angle = 0;
    this.colour = new PVector(200,120,200);
  }
  
  PVector iterate(tile t){
    this.angle+=(t==null)?-90:90;
    return this.calculateVector();
  }
  
  private PVector calculateVector(){
    switch(abs(this.angle % 360)){
      case 0:
        return new PVector(1,0);
      case 90:
        return new PVector(0,1);
      case 180:
        return new PVector(-1,0);
      case 270:
        return new PVector(0,-1);
    }
    return new PVector(1,0);
  }
}

