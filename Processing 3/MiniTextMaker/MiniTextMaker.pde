String input = "Input";
PVector TextColour = new PVector(0,0,0);
PVector bg = getInverseColour(TextColour);

void setup(){
  size(840,560,P2D);
  
  //PFont f = loadFont("ArialMT-48.vlw");
  
  background(bg.x,bg.y,bg.z);
  noStroke();
  fill(TextColour.x,TextColour.y,TextColour.z);
  textAlign(CENTER,CENTER);
  text(input,width/2,height/2);
}

PVector getInverseColour(PVector original){
  return new PVector((~int(original.x))&0xff,(~int(original.y))&0xff,(~int(original.z))&0xff);
}