import javax.swing.JColorChooser;
import java.awt.Color;
Color javaColour;

PVector oldMouse;
PVector mouse;
PImage colours;

slider pixelSize;
int size;

void setup(){
  size(840,560);
  frame.setResizable(true);
  background(0);
  noStroke();
  
  colours=loadImage("colourGradient.png");
  
  pixelSize=new slider(width-50,190,0,27,100);
  
  oldMouse=new PVector(0,0);
  mouse=new PVector(0,0);
}

void draw(){
  loadPixels();
  mouse.set(mouseX,mouseY);
  size=int(pixelSize.getValue());
  
//  for(int y=-5;y<5;y++){
//    for(int x=-5;x<5;x++){
//      drawPixel(mouseX+x,mouseY+y,color(255,0,0));
//    }
//  }
  
  
  if(mousePressed){
    PVector direction=PVector.sub(mouse,oldMouse);
    direction.setMag(1);
    
    PVector position=oldMouse.get();
    
    for(int y=-size;y<size;y++){
      for(int x=-size;x<size;x++){
        if(javaColour!=null){
          drawPixel(int(position.x)+x,int(position.y)+y,color(javaColour.getRed(),javaColour.getGreen(),javaColour.getBlue()));
        }
        else{
          drawPixel(int(position.x)+x,int(position.y)+y,color(255));
        }
      }
    }
    
    while(PVector.dist(position,mouse)>=1){
      if(javaColour!=null){
        drawPixel(int(position.x),int(position.y),color(javaColour.getRed(),javaColour.getGreen(),javaColour.getBlue()));
      }
      else{
        drawPixel(int(position.x),int(position.y),color(255));
      }
      for(int y=-size;y<size;y++){
        for(int x=-size;x<size;x++){
          if(javaColour!=null){
            drawPixel(int(position.x)+x,int(position.y)+y,color(javaColour.getRed(),javaColour.getGreen(),javaColour.getBlue()));
          }
          else{
            drawPixel(int(position.x)+x,int(position.y)+y,color(255));
          }
        }
      }
      position.add(direction);
    }
    
    if(overRect(mouseX,mouseY,pixelSize.x,pixelSize.y,15,pixelSize.size)){
      pixelSize.update(mouseY);
    }
  }
  
  oldMouse.set(mouseX,mouseY);
  updatePixels();
  
  drawGUI();
}

void drawPixel(int x,int y,color colour){
  try{
      pixels[y*width+constrain(x,0,width-100)]=colour;
  }
  catch(ArrayIndexOutOfBoundsException e){}
}

void drawGUI(){
  noStroke();
  fill(102);
  rect(width-100,0,100,height);
  fill(45);
  rect(width-80,20,60,60);
  image(colours,width-78,22,56,56);
  
  pixelSize.render();
  fill(45);
  stroke(155);
  strokeWeight(3);
  rect(width-80,260,60,60);
  
  noStroke();
  if(javaColour!=null){
    fill(javaColour.getRed(),javaColour.getGreen(),javaColour.getBlue());
  }
  else{
    fill(255);
  }
  rectMode(CENTER);
  rect(width-50,290,ceil(pixelSize.getValue()*2),ceil(pixelSize.getValue()*2));
  rectMode(CORNER);
}

boolean overRect(float posX,float posY,float x, float y, float width, float height)  {
  return posX<x+width/2 && posX>x-width/2 && posY<y+height/2 && posY>y-height/2;
}

void mousePressed(){
  if(overRect(mouseX,mouseY,width-50,50,60,60)){
    javaColour=JColorChooser.showDialog(this,"Select a colour...",Color.white);
  }
}


