float[][] depth;
int cellSize=40;

int interval=300;
int lastRecordedTime;

void setup(){
  size(860,520);
  frame.setResizable(true);
  background(0);
  stroke(48);
  
  depth=new float[width/cellSize][height/cellSize];
  depth[width/cellSize/2][height/cellSize/2]=1000;
}

void draw(){
  if(millis()-lastRecordedTime>interval){
    drawFluid();
    lastRecordedTime=millis();
  }
}

void drawFluid(){
  for(int x=0;x<width/cellSize;x++){
    for(int y=0;y<height/cellSize;y++){
      if(depth[x][y]>20){
        for(int xx=x-1;x<=x+1;x++){
          for(int yy=y-1;y<=y+1;y++){
            try{
              depth[xx][yy]+=2;
              depth[x][y]-=2;
            }
            catch(ArrayIndexOutOfBoundsException e){}
          }
        }
      }
      else{
        depth[x][y]-=2;
      }
      fill(color(depth[x][y]-100,depth[x][y]-100,depth[x][y],depth[x][y]));
      rect(x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
}

void mousePressed(){
  for(int x=mouseX/cellSize-1;x<=mouseX/cellSize+1;x++){
    for(int y=mouseY/cellSize-1;y<=mouseY/cellSize+1;y++){
      try{
        depth[x][y]+=16;
      }
      catch(ArrayIndexOutOfBoundsException e){}
    }
  }
}

void mouseDragged(){
  for(int x=mouseX/cellSize-1;x<=mouseX/cellSize+1;x++){
    for(int y=mouseY/cellSize-1;y<=mouseY/cellSize+1;y++){
      try{
        depth[x][y]+=16;
      }
      catch(ArrayIndexOutOfBoundsException e){}
    }
  }
}
