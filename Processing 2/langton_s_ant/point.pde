class point{
  protected PVector colour = new PVector(255,255,255);

  void render(PVector location, PGraphics surface){
    this.render(location.x,location.y,surface);
  }
  
  void render(float x, float y, PGraphics surface){
    surface.noStroke();
    surface.fill(this.colour.x,this.colour.y,this.colour.z);
    surface.rect(int(x), int(y),1,1);
  }
}

