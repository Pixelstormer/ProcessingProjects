import java.util.List;
import java.awt.Color;

Particle p;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  PVector[] vertices = createScaledArray(SHAPE_SQUARE, 5);
  Renderer r = new Renderer(new Color(40,40,40),new Color(100,100,100),3,CLOSE,vertices);
  p = new Particle(new PVector(width/2,height/2),new PVector(0,0),null,r,false,0.9,4);
}

void draw(){
  background(0);
  
  if(mousePressed){
    PVector direction = getDirection(p.getLocation(),new PVector(mouseX,mouseY));
    direction.setMag(200);
    p.apply_force(direction);
  }
  
  p.iter_all();
  p.bounce_off_bounds();
  p.render();
}

PVector getDirection(PVector from, PVector to){
  return PVector.sub(to,from);
}

PVector[] createScaledArray(PVector[] array, float scalar){
  PVector[] copy = new PVector[array.length];
  for(int i=0,j=array.length;i<j;i++){
    copy[i] = PVector.mult(array[i],scalar);
  }
  return copy;
}

PVector[] scaleArray(PVector[] array, float scalar){
  for(PVector p : array){
    p.mult(scalar);
  }
  return array;
}

