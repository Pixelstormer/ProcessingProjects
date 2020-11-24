/**
  * Space Invaders
  *
  * Todo:
  *   - Add barriers
  */

int playerX; //As player can only move horizontally there is no need to track Y
int speed; //Speed the player moves
int lives=4; //Maximum hits player can take before Game Over
int iFrames; //Amount of 'invincibility frames' player has left
int level=1; //Amount of levels player has beaten, and difficulty

int score=0; //Score
String[] highscore; //All-time highscore

int interval=800; //Iterate every this many milliseconds
int lastIterTime=0; //Keep track of last iteration time
float maxInterval=interval; //Original max interval for reference when restarting

boolean[] moving=new boolean[2]; //Keeps track of player movement

ArrayList<shot> activeShots=new ArrayList<shot>(); //Any shots currently onscreen
ArrayList<shot> toRemove=new ArrayList<shot>(); //Shots to be removed next frame

barrier left;
barrier middle;
barrier right;

int aliensInRow=8; //Aliens in a row
int aliensInColumn=8; //Aliens in a column
alien[][] invaders=new alien[aliensInRow][aliensInColumn]; //Array of aliens
boolean direction=false; //Direction aliens are moving
UFO ufo=new UFO(); //The ufo

PImage invader1f1,invader1f2,invader2f1,invader2f2,invader3f1,invader3f2; //Alien sprites
PImage UFOframe1,UFOframe2; //UFO sprites
PImage player; //Player sprite
PFont scoreDisplay; //Font
PFont gameOver; //Other font
PImage barrier; //Barriers

boolean dead; //Is player dead or not
boolean newHighScore=false; //Has the player got a new high score or not

void setup() {
  size(840, 560);
  frame.setResizable(true);
  noSmooth();
  noStroke();
  
  highscore=loadStrings("score.txt");
  
  scoreDisplay=createFont("zx_spectrum-7.ttf",11);
  gameOver=createFont("zx_spectrum-7_bold.ttf",11);
    
  textAlign(CENTER);
  imageMode(CENTER);
  
  fill(255);
  text("Loading",width/2,height/2);

  invader1f1=loadImage("invader_1-f1.png");
  invader1f2=loadImage("invader_1-f2.png");
  invader2f1=loadImage("invader_2-f1.png");
  invader2f2=loadImage("invader_2-f2.png");
  invader3f1=loadImage("invader_3-f1.png");
  invader3f2=loadImage("invader_3-f2.png");
  UFOframe1=loadImage("UFOframe1.png");
  UFOframe2=loadImage("UFOframe2.png");
  player=loadImage("core_cannon.png");
  barrier=loadImage("Barrier.png");
  
  restart();
  lives--;
}

void draw() {
  background(0);
  if(dead){
    fill(255);
    textFont(gameOver);
    textSize(84);
    
    if(score>int(highscore[0])&&!(newHighScore)){
      String[] newHigh=new String[1];
      newHigh[0]=str(score);
      saveStrings("score.txt",newHigh);
      highscore[0]=newHigh[0];
      newHighScore=true;
    }
    
    text("You Lose",width/2,height/2);
    textSize(32);
    text("Final score: "+score+"\nPress Esc to Exit or Space to Restart.",width/2,height/2+32);
    
    if(newHighScore){
      text("New highscore!",width/2,height/2+52);
    }
  }
  else{
    activeShots.removeAll(toRemove);
    for (shot s : activeShots) {
      s.move();
      s.checkCollision();
      s.checkBarriers();
      s.render();
      if (isOutOfBounds(s.x, s.y, 5, 15)) {
        toRemove.add(s);
      }
    }
    
    if(iFrames<0){
      iFrames--;
    }
    
    if(lives<=0){
      dead=true;
    }
    
    movePlayer();
    drawPlayer();
    drawGUI();
  
    boolean iterate=false;
    if (millis()-lastIterTime>interval) {
      iterate=true;
      
      ufo.frame=!(ufo.frame);
      
      lastIterTime=millis();
    }
    
    if(ufo.active){
      ufo.render();
      ufo.move();
    }
  
    boolean allDead=true;
    
    for (int x=0; x<aliensInRow; x++) {
      for (int y=0; y<aliensInColumn; y++) {
        if(allDead){
          allDead=invaders[x][y].dead;
        }
        
        invaders[x][y].render();
        
        invaders[x][y].timeToShoot--;
        if(invaders[x][y].timeToShoot<=0){
          invaders[x][y].shoot();
        }
        
        if (iterate) {
          invaders[x][y].move();
        }
      }
    }
  
    for (int x=0; x<aliensInRow; x++) {
      for (int y=0; y<aliensInColumn; y++) {
        if (isOutOfBounds(invaders[x][y].x, invaders[x][y].y, -25, -25)) {
          if(invaders[x][y].y<height-25){
            direction=!(direction);
            moveDown();
          }
          else{
            dead=true;
          }
        }
      }
    }
    
    left.update();
    left.render();
    middle.update();
    middle.render();
    right.update();
    right.render();
    
    if(allDead){
      level++;
      restart();
    }
  }
}

boolean isOutOfBounds(int x, int y, int Width, int Height) {
  return x>width+Width||x<0-Width||y>height+Height||y<0-Height;
}

boolean overRect(float posX,float posY,float x, float y, float width, float height)  {
  return posX<x+width/2 && posX>x-width/2 && posY<y+height/2 && posY>y-height/2;
}

void moveDown() {
  for (int x=0; x<aliensInRow; x++) {
    for (int y=0; y<aliensInColumn; y++) {
      if(!(invaders[x][y].dead)){
        invaders[x][y].y+=20;
        if (direction) {
          invaders[x][y].x+=10;
        } else {
          invaders[x][y].x-=10;
        }
      }
    }
  }
}

void getHit(){
  if(iFrames<=0){
    lives--;
    iFrames=60;
    score-=7500;
  }
}

void movePlayer() {
  if (moving[0]) {
    playerX-=speed;
  }
  if (moving[1]) {
    playerX+=speed;
  }

  playerX=constrain(playerX, 28, width-28);
}

void drawPlayer() {
  if(iFrames>0){
    tint(0,(iFrames%2)*255,0);
  }
  else{
    noTint();
  }
  image(player,playerX, height/1.15, 44, 44);
}

void drawGUI(){
  fill(0);
  rect(0,height-45,width,45);
  for(int i=1;i<lives;i++){
    noTint();
    image(player,i*30,height-30,25,25);
  }
  fill(255);
  textFont(scoreDisplay);
  textAlign(RIGHT);
  textSize(35);
  text("Score: "+score,width-15,height-30);
  textAlign(CENTER);
  text("Level "+level,width/2,height-30);
}

void playerShoot() {
  int count=0;
  for (shot s : activeShots) {
    if (s.isPlayer) {
      count++;
    }
  }
  if (count<3) {
    activeShots.add(new shot(playerX-3, floor(height/1.15-19.5)));
  }
}

void pollUFO(){
  if(int(random(25))>ufo.chance){
    ufo.active=true;
  }
}

void restart(){
  lives++;
  if(dead){
    lives=4;
    score=0;
    level=1;
    dead=false;
    newHighScore=false;
  }
  
  left=new barrier(width/4,int(height/1.3));
  middle=new barrier(width/2,int(height/1.3));
  right=new barrier(int(width/1.25),int(height/1.3));
  
  playerX=width/2;
  iFrames=120;
  speed=6;
  interval=int(maxInterval)-level*10;
  ufo.active=false;
  ufo.combo=0;
  if(ufo.side){
    ufo.x=width+45;
  }
  else{
    ufo.x=-45;
  }
  
  activeShots.removeAll(activeShots);
  toRemove.removeAll(toRemove);
  
  float i=1.3;
  for (int y=0; y<aliensInRow; y++) {
    for (int x=0; x<aliensInColumn; x++) {
      invaders[x][y]=new alien((width-60)/aliensInRow*(x+1), (height-240)/aliensInColumn*(y+1)+45,floor(i));
    }
    i+=0.3;
  }
}

void keyPressed() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case LEFT:
      moving[0]=true;
      break;
    case RIGHT:
      moving[1]=true;
      break;
    }
    break;
  case 'a':
  case 'A':
    moving[0]=true;
    break;
  case 'd':
  case 'D':
    moving[1]=true;
    break;
  case ' ':
    if(dead){
      restart();
    }
  }
}

void keyReleased() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case LEFT:
      moving[0]=false;
      break;
    case RIGHT:
      moving[1]=false;
      break;
    }
    break;
  case 'a':
  case 'A':
    moving[0]=false;
    break;
  case 'd':
  case 'D':
    moving[1]=false;
    break;
  }
}

void mousePressed(){
  playerShoot();
}
