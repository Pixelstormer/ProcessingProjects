PVector pos1,pos2,pos3,pos4;
PVector camPos;
float imageSize = 25;

void setup(){
  size(840,560);
  frame.setResizable(true);
  camPos = new PVector(width/2,height/2);
  pos1 = camPos.get();
  pos2 = camPos.get();
  pos3 = camPos.get();
  pos4 = camPos.get();
  
  pos1.x-=imageSize;
  pos1.y-=imageSize;
  
  pos2.x+=imageSize;
  pos2.y-=imageSize;
  
  pos3.x+=imageSize;
  pos3.y+=imageSize;
  
  pos4.x-=imageSize;
  pos4.y+=imageSize;
  
  fill(0);
  stroke(120);
}

void draw(){
  background(0);
  camPos = new PVector(mouseX,mouseY);
  
  if(camPos.x-pos1.x>imageSize*2-5){
    pos1.x += imageSize*4;
  }
  if(pos1.x-camPos.x>imageSize*2-5){
    pos1.x -= imageSize*4;
  }
  if(camPos.y-pos1.y>imageSize*2-5){
    pos1.y += imageSize*4;
  }
  if(pos1.y-camPos.y>imageSize*2-5){
    pos1.y -= imageSize*4;
  }
  
  if(camPos.x-pos2.x>imageSize*2-5){
    pos2.x += imageSize*4;
  }
  if(pos2.x-camPos.x>imageSize*2-5){
    pos2.x -= imageSize*4;
  }
  if(camPos.y-pos2.y>imageSize*2-5){
    pos2.y += imageSize*4;
  }
  if(pos2.y-camPos.y>imageSize*2-5){
    pos2.y -= imageSize*4;
  }
  
  if(camPos.x-pos3.x>imageSize*2-5){
    pos3.x += imageSize*4;
  }
  if(pos3.x-camPos.x>imageSize*2-5){
    pos3.x -= imageSize*4;
  }
  if(camPos.y-pos3.y>imageSize*2-5){
    pos3.y += imageSize*4;
  }
  if(pos3.y-camPos.y>imageSize*2-5){
    pos3.y -= imageSize*4;
  }
  
  if(camPos.x-pos4.x>imageSize*2-5){
    pos4.x += imageSize*4;
  }
  if(pos4.x-camPos.x>imageSize*2-5){
    pos4.x -= imageSize*4;
  }
  if(camPos.y-pos4.y>imageSize*2-5){
    pos4.y += imageSize*4;
  }
  if(pos4.y-camPos.y>imageSize*2-5){
    pos4.y -= imageSize*4;
  }
  
  stroke(255,0,0);
  drawGrid(pos1);
  stroke(0,255,0);
  drawGrid(pos2);
  stroke(0,0,255);
  drawGrid(pos3);
  stroke(120);
  drawGrid(pos4);
  
  fill(120);
  noStroke();
  ellipse(camPos.x,camPos.y,5,5);
  drawGrid(camPos);
}

void drawGrid(PVector pos){
  strokeWeight(5);
  line(pos.x-imageSize,pos.y-imageSize,pos.x+imageSize,pos.y-imageSize);
  line(pos.x+imageSize,pos.y-imageSize,pos.x+imageSize,pos.y+imageSize);
  line(pos.x+imageSize,pos.y+imageSize,pos.x-imageSize,pos.y+imageSize);
  line(pos.x-imageSize,pos.y+imageSize,pos.x-imageSize,pos.y-imageSize);
  noStroke();
  ellipse(pos.x,pos.y,5,5);
}
