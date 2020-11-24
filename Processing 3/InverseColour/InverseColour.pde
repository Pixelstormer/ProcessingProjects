PVector Colour = new PVector(0,0,0);

void setup(){
  size(840,560);
  surface.setResizable(true);
  
  PVector bg = getInverseColour(Colour);
  println("Inverse (Complimentary) colour for RBG colour ["+Colour.x+","+Colour.y+","+Colour.z+"] is: ["+bg.x+","+bg.y+","+bg.z+"]");
  background(bg.x,bg.y,bg.z);
  fill(Colour.x,Colour.y,Colour.z);
  noStroke();
  ellipse(width/2,height/2,200,200);
}

PVector getInverseColour(PVector original){
  return new PVector((~int(original.x))&0xff,(~int(original.y))&0xff,(~int(original.z))&0xff);
}