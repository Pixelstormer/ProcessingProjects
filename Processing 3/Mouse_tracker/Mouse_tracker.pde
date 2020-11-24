void setup(){
  size(640,480);
  cursor(CROSS);
}

void draw(){
  background(0);
  float vel=dist(mouseX,mouseY,pmouseX,pmouseY);
  
  stroke(255);
  line(mouseX,mouseY,pmouseX,pmouseY);
  
  fill(255);
  ellipse(pmouseX,pmouseY,5,5);
  ellipse(mouseX,mouseY,5,5);
  
  fill(255);
  text("Mouse coordinates: ("+mouseX+","+mouseY+")",4,15);
  text("PMouse coordinates: ("+pmouseX+","+pmouseY+")",4,30);
  text("Mouse lag (Pixels): "+vel,4,45);
}