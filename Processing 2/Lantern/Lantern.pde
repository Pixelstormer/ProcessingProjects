float time;
ArrayList<Lamp> lanterns=new ArrayList();
ArrayList<Lamp> toRemove=new ArrayList();

ArrayList<Key> Keys=new ArrayList();
ArrayList<Key> collected=new ArrayList();
PImage sprite;

int playerX;
int playerY;
StringList inputBuffer=new StringList();
int speed=12;
int health=200;
int shadowTimer=350;
boolean inShadow;
boolean healthSwitch;

int score;

void setup(){
  size(860, 520);
  frame.setResizable(true);
  textAlign(CENTER);
  PFont font=loadFont("Tunga-Bold-48.vlw");
  textFont(font);
  sprite=loadImage("relic_king_key.png");
  
  startLevel();
}

void draw(){
  background(0);
  fill(map(health,200,-600,0,255),0,0,map(health,200,-600,0,255));
  rect(0,0,width,height);
  
  inShadow=true;
  
  movePlayer();
  
  doLanterns();
  
  doKeys();
  
  checkShadow();
  
  fill(0,40);
  noStroke();
  ellipse(playerX,playerY,15,15);
  
  if(health<-600){
    death();
  }
  
  if(Keys.size()<1){
    startLevel();
  }
}

void movePlayer(){
  if(inputBuffer.hasValue("UP")){
      playerY-=speed;
  }
  if(inputBuffer.hasValue("LEFT")){
    playerX-=speed;
  }
  if(inputBuffer.hasValue("RIGHT")){
    playerX+=speed;
  }
  if(inputBuffer.hasValue("DOWN")){
    playerY+=speed;
  }
  
  playerX=constrain(playerX,1,width-1);
  playerY=constrain(playerY,1,height-1);
}

void doLanterns(){
  for(Lamp l : lanterns){
    l.render();
    if(dist(l.x,l.y,playerX,playerY)<l.range/2-20){
      inShadow=false;
    }
  }
  
  for(Lamp l : toRemove){
    lanterns.remove(l);
  }
}

void doKeys(){
  for(Key k : Keys){
    k.render();
    if(dist(playerX,playerY,k.x,k.y)<30 && shadowTimer<200){
      k.collect();
    }
  }
  
  for(Key k : collected){
    Keys.remove(k);
  }
}

void checkShadow(){
  if(inShadow){
    shadowTimer--;
  }
  else{
    shadowTimer=350;
    if(healthSwitch){
      health++;
    }
    healthSwitch=!(healthSwitch);
  }
  
  if(shadowTimer<0){
    health--;
  }
}

void death(){
  noLoop();
  fill(255);
  textSize(32);
  text("Eaten by the shadows",width/2,height/2);
  textSize(16);
  text("Score: "+score,width/2,height/2+32);
}

void startLevel(){
  playerX=width/2;
  playerY=height/2;
  score=0;
  health=200;
  
  for(Lamp l : lanterns){
    toRemove.add(l);
  }
  
  for(Key k : Keys){
    collected.add(k);
  }
  
  for(int i=0; i<random(3,6); i++){
    lanterns.add(new Lamp(random(width),random(height),random(40,160)));
  }
  lanterns.add(new Lamp(width/2,height/2,200));
  
  for(int i=0; i<random(5,8); i++){
    Keys.add(new Key(random(width),random(height)));
  }
}

void mousePressed(){
  switch(mouseButton){
    case LEFT:
      lanterns.add(new Lamp(mouseX,mouseY,160));
      break;
    case RIGHT:
      for(Lamp l : lanterns){
        if(dist(mouseX,mouseY,l.x,l.y)<l.range/2-l.range/5){
          toRemove.add(l);
          break;
        }
      }
  }
}

void keyPressed(){
  switch(key){
      case CODED:
        switch(keyCode){
          case UP:
            inputBuffer.set(0,"UP");
            break;
          case RIGHT:
            inputBuffer.set(1,"RIGHT");
            break;
          case LEFT:
            inputBuffer.set(2,"LEFT");
            break;
          case DOWN:
            inputBuffer.set(3,"DOWN");
            break;
        }
        break;
      case 'w':
      case 'W':
        inputBuffer.set(0,"UP");
        break;
      case 'd':
      case 'D':
        inputBuffer.set(1,"RIGHT");
        break;
      case 'a':
      case 'A':
        inputBuffer.set(2,"LEFT");
        break;
      case 's':
      case 'S':
        inputBuffer.set(3,"DOWN");
        break;
      case ' ':
        startLevel();
        break;
    }
}

void keyReleased(){
  switch(key){
      case CODED:
        switch(keyCode){
          case UP:
            inputBuffer.set(0,null);
            break;
          case RIGHT:
            inputBuffer.set(1,null);
            break;
          case LEFT:
            inputBuffer.set(2,null);
            break;
          case DOWN:
            inputBuffer.set(3,null);
            break;
        }
        break;
      case 'w':
      case 'W':
        inputBuffer.set(0,null);
        break;
      case 'd':
      case 'D':
        inputBuffer.set(1,null);
        break;
      case 'a':
      case 'A':
        inputBuffer.set(2,null);
        break;
      case 's':
      case 'S':
        inputBuffer.set(3,null);
        break;
    }
}


