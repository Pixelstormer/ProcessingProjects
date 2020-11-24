int[][] tiles;
int tilesInRow=28; //28
int tilesInColumn=31; //31
int tileSize=16;

int playerX,playerY;
IntList inputBuffer=new IntList(); //38=UP,40=DOWN,37=LEFT,39=RIGHT
int direction;
int playerSpeed=1;

PVector sprite;
PVector target;

int currentDirection;
int nextDirection;

int score=0;

void setup(){
  size(840,560);
  frame.setResizable(true);
  rectMode(CENTER);
  
  playerX=width/2+tileSize*(tilesInRow/2)-tilesInRow/2*tileSize;
  playerY=height/2+tileSize*(tilesInColumn/2+2)-tilesInColumn/2*tileSize;
  sprite=new PVector(playerX,playerY);
  target=new PVector(playerX,playerY);
  
  inputBuffer.append(RIGHT);
  currentDirection=RIGHT;
  nextDirection=RIGHT;
  setupTiles();
}

void draw(){
  background(0);
  fill(102);
  for(int x=0;x<tilesInRow;x++){
    for(int y=0;y<tilesInColumn;y++){
      stroke(0,0,255);
      strokeWeight(3);
      pushMatrix();
      translate(width/2+tileSize*x-tilesInRow/2*tileSize,height/2+tileSize*y-tilesInColumn/2*tileSize);
      switch(tiles[x][y]){
        case 0: //Empty
          fill(0);
          break;
        case 1: //Pellet
          fill(0,0);
          stroke(#F7C3C3);
          point(0,0);
          noStroke();
          break;
        case 2: //Power pellet
          fill(0,0);
          stroke(#F7C3C3);
          strokeWeight(14);
          point(0,0);
          noStroke();
          break;
        case 3: //Horizontal wall
          line(-8,0,8,0);
          break;
        case 4: //Vertical wall
          line(0,-8,0,8);
          break;
        case 5: //Top-left corner
          arc(8,8,tileSize,tileSize,radians(180),radians(270),OPEN);
          break;
        case 6: //Top-right corner
          arc(-8,8,tileSize,tileSize,radians(270),radians(360),OPEN);
          break;
        case 7: //Bottom-left corner
          arc(8,-8,tileSize,tileSize,radians(90),radians(180),OPEN);
          break;
        case 8: //Bottom-right corner
          arc(-8,-8,tileSize,tileSize,radians(0),radians(90),OPEN);
          break;
        case 9: //Horizontal double-wall
          line(-8,-4,8,-4);
          line(-8,4,8,4);
          break;
        case 10: //vertical double-wall
          line(-4,-8,-4,8);
          line(4,-8,4,8);
          break;
        case 11: //Double top-left corner
          arc(6,6,tileSize/4,tileSize/4,radians(180),radians(270),OPEN);
          arc(6,6,tileSize/0.75-2,tileSize/0.75-2,radians(180),radians(270),OPEN);
          break;
        case 12: //Double top-right corner
          arc(-6,6,tileSize/4,tileSize/4,radians(270),radians(360),OPEN);
          arc(-6,6,tileSize/0.75,tileSize/0.75-2,radians(270),radians(360),OPEN);
          break;
        case 13: //Double bottom-left corner
          arc(6,-6,tileSize/4,tileSize/4,radians(90),radians(180),OPEN);
          arc(6,-6,tileSize/0.75-2,tileSize/0.75,radians(90),radians(180),OPEN);
          break;
        case 14: //Double bottom-right corner
          arc(-6,-6,tileSize/4,tileSize/4,radians(0),radians(90),OPEN);
          arc(-6,-6,tileSize/0.75,tileSize/0.75,radians(0),radians(90),OPEN);
          break;
        case 15: //Square top-left corner
          rotate(radians(90));
          line(4,-4,6,-4);
          line(4,-4,4,-6);
          line(-4,4,6,4);
          line(-4,4,-4,-6);
          break;
        case 16: //Square top-right corner
          rotate(radians(180));
          line(4,-4,6,-4);
          line(4,-4,4,-6);
          line(-4,4,6,4);
          line(-4,4,-4,-6);
          break;
        case 17: //Square bottom-left corner
          line(4,-4,6,-4);
          line(4,-4,4,-6);
          line(-4,4,6,4);
          line(-4,4,-4,-6);
          break;
        case 18: //Square bottom-right corner
          rotate(radians(270));
          line(4,-4,6,-4);
          line(4,-4,4,-6);
          line(-4,4,6,4);
          line(-4,4,-4,-6);
          break;
        case 19: //Horizontal double-wall left transition
          arc(-2,6,tileSize/4,tileSize/4,radians(270),radians(360),OPEN);
          line(-2,4,-6,4);
          line(-8,-4,8,-4);
          break;
        case 20: //Horizontal double-wall right transition
          arc(2,6,tileSize/4,tileSize/4,radians(180),radians(270),OPEN);
          line(2,4,6,4);
          line(-8,-4,8,-4);
          break;
        case 21: //Vertical left-wall upper transition
          arc(6,-2,tileSize/4,tileSize/4,radians(90),radians(180),OPEN);
          line(4,-2,4,-8);
          line(-4,-8,-4,8);
          break;
        case 22: //Vertical left-wall lower transition
          arc(6,2,tileSize/4,tileSize/4,radians(180),radians(270),OPEN);
          line(4,2,4,8);
          line(-4,-8,-4,8);
          break;
        case 23: //Vertical right-wall upper transition
          rotate(radians(180));
          arc(6,-2,tileSize/4,tileSize/4,radians(90),radians(180),OPEN);
          line(4,-2,4,-8);
          line(-4,-8,-4,8);
          break;
        case 24: //Vertical right-wall lower transition
          rotate(radians(180));
          arc(6,2,tileSize/4,tileSize/4,radians(180),radians(270),OPEN);
          line(4,2,4,8);
          line(-4,-8,-4,8);
          break;
        case 25: //Ghost box door
          stroke(#F2A4C5);
          line(-8,0,8,0);
          break;
      }
    popMatrix();
    }
  }
  
  newMovePlayer();
  renderPlayer();
  
  fill(255);
  text(score,4,15);
  text(frameRate,4,30);
}

//void movePlayer(){
//  
//  try{
//    direction=inputBuffer.get(0);
//  }
//  catch(ArrayIndexOutOfBoundsException e){}
//  
//  int oldDirection=direction;
//  
//  int x=playerX;
//  int y=playerY;
//  
//  switch(direction){
//    case UP:
//      playerY-=playerSpeed;
//      break;
//    case DOWN:
//      playerY+=playerSpeed;
//      break;
//    case LEFT:
//      playerX-=playerSpeed;
//      break;
//    case RIGHT:
//      playerX+=playerSpeed;
//      break;
//  }
//  
//  int xSquare=(playerX+tilesInRow/2*tileSize-width/2)/tileSize;
//  int ySquare=(playerY+tilesInColumn/2*tileSize-height/2)/tileSize;
//  
//  if(tiles[xSquare][ySquare]==3){
//    playerX=x;
//    playerY=y;
//    direction=oldDirection;
//  }
//  else{
//    try{
//      inputBuffer.remove(0);
//    }
//    catch(ArrayIndexOutOfBoundsException e){}
//  }
//}

void newMovePlayer(){
  nextDirection=inputBuffer.get(0);
  
  int oldX=playerX;
  int oldY=playerY;
  
  int xSquare=0;
  int ySquare=0;
  
  switch(currentDirection){
    case UP:
      playerY-=playerSpeed;
      
      xSquare=(playerX+tilesInRow/2*tileSize-width/2)/tileSize;
      ySquare=(playerY-tileSize/2+tilesInColumn/2*tileSize-height/2)/tileSize;
      break;
    case DOWN:
      playerY+=playerSpeed;
      
      xSquare=(playerX+tilesInRow/2*tileSize-width/2)/tileSize;
      ySquare=(playerY+tileSize/2+tilesInColumn/2*tileSize-height/2)/tileSize;
      break;
    case LEFT:
      playerX-=playerSpeed;
      
      xSquare=(playerX-tileSize/2+tilesInRow/2*tileSize-width/2)/tileSize;
      ySquare=(playerY+tilesInColumn/2*tileSize-height/2)/tileSize;
      break;
    case RIGHT:
      playerX+=playerSpeed;
      
      xSquare=(playerX+tileSize/2+tilesInRow/2*tileSize-width/2)/tileSize;
      ySquare=(playerY+tilesInColumn/2*tileSize-height/2)/tileSize;
      break;
  }
  
  if(tiles[xSquare][ySquare]>2){ //Wall
    playerX=oldX;
    playerY=oldY;
  }
  else if(tiles[xSquare][ySquare]==1){ //Pellet
    tiles[xSquare][ySquare]=0;
    score+=100;
  }
  else if(tiles[xSquare][ySquare]==2){ //Power Pellet
    tiles[xSquare][ySquare]=0;
    score+=1100;
    
    //Also go super-mode (When ghosts are added)
  }
  
  xSquare=(playerX+tilesInRow/2*tileSize-width/2)/tileSize;
  ySquare=(playerY+tilesInColumn/2*tileSize-height/2)/tileSize;
  
  fill(255);
  noStroke();
  rect(width/2+tileSize*xSquare-tilesInRow/2*tileSize,height/2+tileSize*ySquare-tilesInColumn/2*tileSize,tileSize,tileSize);
  
  int nextXSquare=xSquare;
  int nextYSquare=ySquare;
  
  switch(nextDirection){
    case UP:
      nextYSquare-=1;
      break;
    case DOWN:
      nextYSquare+=1;
      break;
    case LEFT:
      nextXSquare-=1;
      break;
    case RIGHT:
      nextXSquare+=1;
      break;
  }
  
      fill(255,0,0);
      rect(width/2+tileSize*nextXSquare-tilesInRow/2*tileSize,height/2+tileSize*nextYSquare-tilesInColumn/2*tileSize,tileSize,tileSize);
      
      target.set(width/2+tileSize*nextXSquare-tilesInRow/2*tileSize,height/2+tileSize*nextYSquare-tilesInColumn/2*tileSize);
      
  try{
    if(tiles[nextXSquare][nextYSquare]<3){
      currentDirection=nextDirection;
    }
  }
  catch(ArrayIndexOutOfBoundsException e){
    if(int(e.getMessage())>0){
      playerX=width/2+tileSize*0-tilesInRow/2*tileSize;
    }
    else if(int(e.getMessage())<0){
      playerX=width/2+tileSize*tilesInRow-tilesInRow/2*tileSize;
    }
  }
}

void renderPlayer(){
  int x=width/2+tileSize*((playerX+tilesInRow/2*tileSize-width/2)/tileSize)-tilesInRow/2*tileSize;
  int y=height/2+tileSize*((playerY+tilesInColumn/2*tileSize-height/2)/tileSize)-tilesInColumn/2*tileSize;
  
  PVector square=new PVector(x,y);
  
  PVector direction=PVector.sub(target,sprite);
  direction.setMag(playerSpeed);
  
  if(PVector.dist(sprite,target)>5){
//    switch(currentDirection){
//      case UP:
//        spriteY-=playerSpeed;
//        break;
//      case DOWN:
//        spriteY+=playerSpeed;
//        break;
//      case LEFT:
//        spriteX-=playerSpeed;
//        break;
//      case RIGHT:
//        spriteX+=playerSpeed;
//        break;
//    }

    sprite.add(direction);
  }
  
  fill(255,255,0);
  noStroke();
  ellipse(sprite.x,sprite.y,25,25);
  
  fill(255);
//  rect(width/2+tileSize*playerX-tilesInRow/2*tileSize,height/2+tileSize*playerY-tilesInColumn/2*tileSize,15,15);
//  stroke(0,255,0);
//  strokeWeight(3);
//  int x=(playerX+tilesInRow/2*tileSize-width/2)/tileSize;
//  int y=(playerY+tilesInColumn/2*tileSize-height/2)/tileSize;
//  rect(width/2+tileSize*x-tilesInRow/2*tileSize,height/2+tileSize*y-tilesInColumn/2*tileSize,tileSize,tileSize);
  noStroke();
}

void setupTiles(){
  tiles=new int[tilesInRow][tilesInColumn];
  
  BufferedReader tileReader=createReader("tileMap.txt");
  String currentLine="";
  
  int y=0;
  while(currentLine!=null){
    try{
      currentLine=tileReader.readLine();
    }
    catch(IOException e){
      e.printStackTrace();
      currentLine=null;
    }
    
    if(currentLine==null){
      break;
    }
    else{
      String[] line=split(currentLine,',');
      for(int x=0;x<line.length;x++){
        tiles[x][y]=int(line[x]);
      }
      y++;
    }
  }
  try{
    tileReader.close();
  }
  catch(IOException e){
    e.printStackTrace();
  }
}

void keyPressed(){
  inputBuffer.clear();
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          inputBuffer.append(UP);
          break;
        case DOWN:
          inputBuffer.append(DOWN);
          break;
        case LEFT:
          inputBuffer.append(LEFT);
          break;
        case RIGHT:
          inputBuffer.append(RIGHT);
          break;
      }
      break;
    case 'w':
    case 'W':
      inputBuffer.append(UP);
      break;
    case 's':
    case 'S':
      inputBuffer.append(DOWN);
      break;
    case 'a':
    case 'A':
      inputBuffer.append(LEFT);
      break;
    case 'd':
    case 'D':
      inputBuffer.append(RIGHT);
      break;
  }
}


