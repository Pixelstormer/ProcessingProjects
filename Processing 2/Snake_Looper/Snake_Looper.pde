/**
 * The classic game of Snake, with wrap-around walls, programmed in Processing.
 */

int cellSize=10; //Size of each 'cell' - Larger number=smaller playing field and Vice Versa
int[][] cells; //State of each cell (0=black empty, 1=green snake, 2=red fruit

int snakeX,snakeY; //Coordinates for snake 'head' to track movement
int segments=5; //Number of snake segments 
int[][] segmentLife; //For tracking the 'life' of each snake segmen

int direction; //0=up, 1=right, 2=down, 3=left
IntList inputBuffer;

// Variables for iteration timer
float interval = 100;
int lastRecordedTime;

int fruitX,fruitY; //Current coordinates of fruit

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
  
  highScore=loadStrings("score.txt"); //Load highscore
  
  //Setting up cell grids
  cells = new int[width/cellSize][height/cellSize];
  segmentLife=new int[width/cellSize][height/cellSize];
  
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cells[x][y]=0; //Set all squares to black
      segmentLife[x][y]=0;
    }
  }
  
  //Temporary variables to sync cell positions and variable coords;
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
  if(started){ //If(started) encompasses the whole of draw()
    if(!(dead)){ //If not dead, run the game. Else, show the death screen and scores
      for (int x=0; x<width/cellSize; x++) { //Iterating through all the cells
        for (int y=0; y<height/cellSize; y++) {
          switch(cells[x][y]){ //Fill each cell with the appropriate colour
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
          rect(x*cellSize,y*cellSize,cellSize,cellSize); //Draw cells
        }
      }
      if (millis()-lastRecordedTime>interval) { //Timer to move snake every however often, instead of every frame
        updateSegments();
        moveSnake();
        lastRecordedTime = millis();
      }
    }else{ //else of if(!(dead))
      fill(180);
      
      if(currentScore>int(highScore[0])){ //If score is higher than highscore, save new highscore
        String[] newScore=new String[1];
        newScore[0]=str(currentScore);
        saveStrings("score.txt",newScore);
        text("New highscore!",width/2,height/1.8);
        highScore[0]=newScore[0];
      }
      
      //Cause of death, final score and highscore
      text("You "+deathCause+".\nFinal score: "+currentScore+"\nHighscore: "+highScore[0],width/2,height/2.2);
      text("Press Esc to exit, or Space to restart.",width/2,height/1.2);
      
      //Basically restarts all variables and begins the game anew
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
  }else{ //Else of if(started)
    text("Grid-based snake, with wrap-around walls\nPress Space to begin.\nUse WASD or Arrow Keys to move.",width/2,height/2);
  }
}

void moveSnake(){
  direction=getInput();
  
  //Update snake 'head' position
  switch(direction){
    case 0:
      snakeY++;
      break;
    case 1:
      snakeX++;
      break;
    case 2:
      snakeY--;
      break;
    case 3:
      snakeX--;
      break;
  }
  
  //Handles wrapping around the edges of the screen
  if(snakeX>=width/cellSize){
    snakeX=0;
  }else if(snakeX<0){
    snakeX=width/cellSize-1;
  }
  
  if(snakeY>=height/cellSize){
    snakeY=0;
  }else if(snakeY<0){
    snakeY=height/cellSize-1;
  }
  
  switch(cells[snakeX][snakeY]){
    case 2:
      eatFruit();
      break;
    case 1:
      kill("ran into yourself");
      break;
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
  interval--;
  currentScore++;
  
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

