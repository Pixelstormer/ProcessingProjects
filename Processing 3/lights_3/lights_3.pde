/* 
 * Lights v3
 * My most sucessfull attempt at a lighting system so far.
 */

light red;
light green;
light blue;

boolean renderRed;
boolean renderGreen;
boolean renderBlue;

void setup(){
  size(840,560);
  surface.setResizable(true);
  
  red=new light(round(width/3),height/2,120,16);
  green=new light(width/2,height/2,120,8);
  blue=new light(round(width/1.5),height/2,120,0);
  
//  background(0);
  noLoop();
  redraw();
}

void draw(){
  loadPixels();
  if(renderRed){
    shiftPixels(16);
    red.render();
  }
  if(renderGreen){
    shiftPixels(8);
    green.render();
  }
  if(renderBlue){
    shiftPixels(0);
    blue.render();
  }
  updatePixels();
}

void shiftPixels(int shifter){
  for(int i=0;i<pixels.length;i++){
    int mask= ~(0xFF << shifter);
    pixels[i]=pixels[i]&mask; //Remove/comment out this line for mad visuals
  }
}

void keyPressed(){
  loadPixels();
  renderRed=false;
  renderGreen=false;
  renderBlue=false;
  switch(key){
    case 'r':
    case 'R':
      red.move(mouseX,mouseY);
      renderRed=true;
      break;
    case 'g':
    case 'G':
      green.move(mouseX,mouseY);
      green.render();
      renderGreen=true;
      break;
    case 'b':
    case 'B':
      blue.move(mouseX,mouseY);
      blue.render();
      renderBlue=true;
      break;
  }
  updatePixels();
  redraw();
}