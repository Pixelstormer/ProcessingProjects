/*  
 * Lights v3
 * My most sucessfull attempt at a lighting system so far.
 *
 * Ditched attempting to make lights loop - I can do it but it's very laggy;
 * Gave up on trying to make lagless looping.
 */

light red;
light green;
light blue;

boolean clearLight=true; //DisabSle this to stop clearing the respective colour channel after placing a light, leading to cool visual effects

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  red=new light(round(width/3),height/2,120,16);
  green=new light(width/2,height/2,120,8);
  blue=new light(round(width/1.5),height/2,120,0);
  
  background(0);
}

void draw(){
  background(0);
  loadPixels();
//  red.move(round(random(width)),round(random(height)));
//  green.move(round(random(width)),round(random(height)));
//  blue.move(round(random(width)),round(random(height)));

  red.render();
  
  green.render();
  
  blue.render();
  
  updatePixels();
  
  text(frameRate,15,15);
}

void shiftPixels(int shifter){
  for(int i=0;i<pixels.length;i++){
    int mask= ~(0xFF << shifter);
    pixels[i]=pixels[i]&mask;
  }
}

void keyPressed(){
  loadPixels();
  switch(key){
    case 'r':
    case 'R':
      red.move(mouseX,mouseY);
      break;
    case 'g':
    case 'G':
      green.move(mouseX,mouseY);
      break;
    case 'b':
    case 'B':
      blue.move(mouseX,mouseY);
      break;
    case 'c':
    case 'C':
      shiftPixels(0);
      shiftPixels(8);
      shiftPixels(16);
      break;
    case ' ':
      clearLight=!(clearLight);  
  }
  updatePixels();
}

