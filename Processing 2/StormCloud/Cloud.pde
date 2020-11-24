private class Cloud{
  private NoiseField Static;
  private PVector Location;
  
  private Cloud(int xRange, int yRange, double max, double min, double stable, PVector offset, int o, double f, double i){
    this.Static = new NoiseField(xRange,yRange,max,min,stable,offset,o,f,i);
    this.Location = new PVector(width/2,height/2);
  }
  
  private void Update(){
    this.Static.doUpdateSequence();
  }
  
  private void Render(){
    double[][] StaticField = this.Static.getField();
    colorMode(HSB,360);
    for(int x=0;x<this.Static.xRange;x++){
      for(int y=0;y<this.Static.yRange;y++){
        PVector loc = new PVector((float)x,(float)y);
        loc.add(this.Location.get());
        if(StaticField[x][y] > 0.999){
          pixels[int(loc.y)*width+int(loc.x)] = color(190,255,(int)(StaticField[x][y]*255));
        }
      }
    }
    colorMode(RGB,255);
    fill(120);
    noStroke();
    ellipse(this.Location.x,this.Location.y,320,145);
  }
}


