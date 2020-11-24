/**
 * The classic game of Snake, programmed in Processing.
 */

int cellSize=10; //Size of cells - Larger number=smaller playing field and Vice Versa
int[][] cells; //State of each cell (0=black empty, 1=green snake, 2=red fruit

int snakeX,snakeY; //Coordinates for snake 'head'
int segments=5; //Number of snake segments (Value assigned here is no. at beginning of game)
int[][] segmentLife; //'Life' of each snake segment
int speed = 1;

int direction; //0=up, 1=right, 2=down, 3=left
IntList inputBuffer;

// Variables for iteration timer
float interval = 100;
int lastRecordedTime;

int fruitX,fruitY; //Coordinates of fruit

//Colours for cells
color empty=color(0);
color snake=color(0,255,0);
color fruit=color(255,0,0);

boolean dead=false; //If dead or not
String deathCause; //String cause of death - Combined with kill() function allows for any 'death'

String[] highScore; //All-time high score
int currentScore; //Score for current game

boolean started=false; //For initiating the game - the 'start screen' when you first load the program

void setup(){
  size(640,480);
  noSmooth();
  stroke(48);
  textAlign(CENTER);
  
  highScore=loadStrings("score.txt");
  
  cells = new int[width/cellSize][height/cellSize];
  segmentLife=new int[width/cellSize][height/cellSize];
  
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cells[x][y]=0; //Set all squares to black
      segmentLife[x][y]=0;
    }
  }
  
  //Temporary variables to sync cells[][] positions and coords;
  int fx=floor(random(width/cellSize));
  int fy=floor(random(height/cellSize));
  cells[fx][fy]=2; //Fruit starts in random position
  fruitX=fx;
  fruitX=fy;
  
  cells[(width/cellSize)/2][(height/cellSize)/2]=1; //Snake starts in center
  snakeX=(width/cellSize)/2;
  snakeY=(height/cellSize)/2;
  
  inputBuffer=new IntList();
  inputBuffer.append(1);
  
  background(0);
}

void draw(){
  if(started){
    if(!(dead)){
      for (int x=0; x<width/cellSize; x++) {
        for (int y=0; y<height/cellSize; y++) {
          switch(cells[x][y]){
            case 0:
              fill(empty);
              break;
            case 1:
              fill(snake);
              break;
            case 2:
              fill(fruit);
              break;
          }
          rect(x*cellSize,y*cellSize,cellSize,cellSize);
        }
      }
      if (millis()-lastRecordedTime>interval) {
        updateSegments();
        moveSnake();
        lastRecordedTime = millis();
      }
    }else{
      fill(180);
      
      if(currentScore>int(highScore[0])){
        String[] newScore=new String[1];
        newScore[0]=str(currentScore);
        saveStrings("score.txt",newScore);
        text("New highscore!",width/2,height/1.8);
        highScore[0]=newScore[0];
      }
      
      text("You "+deathCause+".\nFinal score: "+currentScore+"\nHighscore: "+highScore[0],width/2,height/2.2);
      text("Press Esc to exit, or Space to restart.",width/2,height/1.2);
      
      if(keyPressed&&key==' '){
        for (int x=0; x<width/cellSize; x++) {
          for (int y=0; y<height/cellSize; y++) {
            cells[x][y]=0;
            segmentLife[x][y]=0;
          }
        }
        
        segments=5;
        currentScore=0;
        highScore=loadStrings("score.txt");
        inputBuffer.clear();
        inputBuffer.append(1);
        interval=100;
        
        snakeX=(width/cellSize)/2;
        snakeY=(height/cellSize)/2;
        cells[(width/cellSize)/2][(height/cellSize)/2]=1;
        
        int fx=floor(random(width/cellSize));
        int fy=floor(random(height/cellSize));
        cells[fx][fy]=2;
        fruitX=fx;
        fruitX=fy;
        
        dead=false;
      }
    }
  }else{
    text("Grid-based snake\nPress Space to begin.\nUse WASD or Arrow Keys to move.",width/2,height/2);
  }
}

void moveSnake(){
  direction=getInput();
  
  //Update snake 'head' position
  switch(direction){
    case 0:
      snakeY+=speed;
      break;
    case 1:
      snakeX+=speed;
      break;
    case 2:
      snakeY-=speed;
      break;
    case 3:
      snakeX-=speed;
      break;
  }
  
  try{
    switch(cells[snakeX][snakeY]){
    case 2:
      eatFruit();
      break;
    case 1:
      kill("ran into yourself");
      break;
    }
  }catch(ArrayIndexOutOfBoundsException e){
    snakeX=(width/cellSize)/2;
    snakeY=(height/cellSize)/2;
    kill("ran into a wall");
  }
  cells[snakeX][snakeY]=1;
  segmentLife[snakeX][snakeY]=segments;
}

int getInput(){
  int i=inputBuffer.get(0);
  try{
    inputBuffer.remove(0);
  }catch(ArrayIndexOutOfBoundsException e){}
  return i;
}

void updateSegments(){
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if(cells[x][y]!=2){
        if(segmentLife[x][y]>0){
          segmentLife[x][y]--;
        }else{
          cells[x][y]=0;
        }
      }
    }
  }
}

void eatFruit(){
  segments+=8;
  currentScore++;
  interval--;
  
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if(cells[x][y]==1){
        segmentLife[x][y]+=8;
      }
    }
  }
  
  while(cells[fruitX][fruitY]!=0){
    fruitX=floor(random(width/cellSize));
    fruitY=floor(random(height/cellSize));
  }
  cells[fruitX][fruitY]=2;
}

void kill(String d){
  dead=true;
  deathCause=d;
}
    
void keyPressed(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          if(direction!=0){
            inputBuffer.append(2);
          }
          break;
        case RIGHT:
          if(direction!=3){
            inputBuffer.append(1);
          }
          break;
        case LEFT:
          if(direction!=1){
            inputBuffer.append(3);
          }
          break;
        case DOWN:
          if(direction!=2){
            inputBuffer.append(0);
          }
          break;
      }
      break;
    case 'w':
    case 'W':
      if(direction!=0){
        inputBuffer.append(2);
      }
      break;
    case 'd':
    case 'D':
      if(direction!=3){
        inputBuffer.append(1);
      }
      break;
    case 's':
    case 'S':
      if(direction!=2){
        inputBuffer.append(0);
      }
      break;
    case 'a':
    case 'A':
      if(direction!=1){
        inputBuffer.append(3);
      }
      break;
    case ' ':
      started=true;
      break;
  }
}

