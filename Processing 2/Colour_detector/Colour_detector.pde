/**
 * Colour detector
 *
 * Detects red, blue, green and opacity values
 * of the pixel the mouse is over
 */

float angle,xSpace;
float scalar=180;
color lerpColour=color(80);

void setup(){
  size(640,480);
  rectMode(CENTER);
}

void draw(){
  background(0);
  
  noStroke();
  
  fill(80);
  ellipse(width/3,height/2,100,100);
  
  fill(150,0,50);
  rect(width/1.5,height/2,100,100,55);
  
  float radAngle=radians(angle);  
  fill(0,102,153);
  xSpace=width/2+(scalar*cos(radAngle));
  ellipse(xSpace,height/6,80,80);
  
  fill(105,203,56,100);
  rect(width/2,height/6,80,80,10);
  
  fill(255);
  rect(width/5.9,height/1.24,120,120,20);
  
  fill(255,0,0,120);
  ellipse(width/6.8,height/1.2,60,60);
  fill(0,255,0,120);
  ellipse(width/5.2,height/1.2,60,60);
  fill(0,0,255,120);
  ellipse(width/5.9,height/1.28,60,60);
  
  loadPixels();
  color pixel=pixels[mouseY*width+mouseX];
  
  int opacity = (pixel >> 24) & 0xFF;
  int red = (pixel >> 16) & 0xFF;
  int green = (pixel >> 8) & 0xFF;
  int blue = pixel & 0xFF; 
  
  lerpColour=lerpColor(lerpColour,pixel,0.04);
  
  stroke(255);
  
  fill(pixel);
  ellipse(width/1.2,height/1.2,40,40);
  
  fill(lerpColour);
  rect(width/2,height/1.2,200,25);
  
  angle+=2;
}
