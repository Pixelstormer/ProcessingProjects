class Renderer{
  //Renders a shape
  
  private Color fill;
  private Color stroke;
  private float strokeWeight;
  
  private float w;
  private float h;
  private int shapeType;
  private PVector[] vertices;
  
  Renderer(Color fill, Color stroke, float strokeWeight, int shapeType, PVector[] vertices){
    this.fill = fill;
    this.stroke = stroke;
    this.strokeWeight = strokeWeight;
    this.shapeType = shapeType;
    this.vertices = vertices;
  }
  
  Renderer(Color fill, int shapeType, PVector[] vertices){
    this.fill = fill;
    this.strokeWeight = 0;
    this.stroke = new Color(0,0,0,0);
    this.shapeType = shapeType;
    this.vertices = vertices;
  }
  
  Renderer(Color stroke, float weight, int shapeType, PVector[] vertices){
    this.stroke = stroke;
    this.strokeWeight = weight;
    this.fill = new Color(0,0,0,0);
    this.shapeType = shapeType;
    this.vertices = vertices;
  }
  
  void render(PVector location){
    fill(this.fill.getRed(), this.fill.getGreen(), this.fill.getBlue(), this.fill.getAlpha());
    stroke(this.stroke.getRed(), this.stroke.getGreen(), this.stroke.getBlue(), this.stroke.getAlpha());
    strokeWeight(this.strokeWeight);
    if(this.shapeType != CLOSE){
      beginShape(this.shapeType);
    }
    else{
      beginShape();
    }
    for(PVector p : this.vertices){
      PVector r = PVector.add(p,location);
      vertex(r.x,r.y);
    }
    if(this.shapeType == CLOSE){
      endShape(this.shapeType);
    }
    else{
      endShape();
    }
  }
  
  void render_with_restoration(PVector location){
    pushStyle();
    this.render(location);
    popStyle();
  }
}
