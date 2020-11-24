private class NoiseField{
  private double[][] Field;
  private int xRange;
  private int yRange;
  private double maxValue;
  private double minValue;
  private double stableValue;
  private PVector noiseOffset;
  
  private int OCTAVES;
  private double FALLOFF;
  private double INCREMENT;
  private double NOISE;
  
  private NoiseField(int xRange, int yRange, double max, double min, double stable, PVector offset, int o, double f, double i){
    this.xRange = xRange;
    this.yRange = yRange;
    this.Field = new double[this.xRange][this.yRange];
    this.maxValue = max;
    this.minValue = min;
    this.stableValue = stable;
    this.noiseOffset = offset.get();
    
    this.OCTAVES = o;
    this.FALLOFF = f;
    this.INCREMENT = i;
    
    this.construct();
  }
  
  private void construct(){
    for(int x=0;x<this.xRange;x++){
      for(int y=0;y<this.yRange;y++){
        double Value = random((float)this.minValue,(float)this.maxValue);
        this.Field[x][y] = Value;
      }
    }
  }
  
  private void setOffset(PVector o){
    this.noiseOffset = o.get();
  }
  
  private void incrementOffset(PVector i){
    this.noiseOffset.add(i.get());
  }
  
  private void doUpdateSequence(){
    this.preUpdate();
    this.Update();
    this.postUpdate();
  }
  
  private void preUpdate(){
    noiseDetail(this.OCTAVES,(float)this.FALLOFF);
    this.NOISE += this.INCREMENT;
  }
  
  private void Update(){
    for(int x=0;x<this.xRange;x++){
      for(int y=0;y<this.yRange;y++){
        double Value = this.Field[x][y];
//        float Noise = noise(x+this.noiseOffset.y*(float)this.INCREMENT,y+this.noiseOffset.y*(float)this.INCREMENT,(float)this.NOISE+this.noiseOffset.z);
        float Noise = random((float)this.minValue,(float)this.maxValue);
        Value = Noise;
        this.Field[x][y] = Value;
      }
    }
  }
  
  private void postUpdate(){
    
  }
  
  private double[][] getField(){
    return this.Field;
  }
}
