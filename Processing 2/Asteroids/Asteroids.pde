int[] inputs=new int[4];
int lives=3;
float iframes=0;
int score;
int level=0;
int levelCounter=300;

ArrayList<laser> lasers=new ArrayList<laser>();
ArrayList<laser> toRemove=new ArrayList<laser>();

ArrayList<asteroid> rocks=new ArrayList<asteroid>();
ArrayList<asteroid> toSplit=new ArrayList<asteroid>();

PFont display;
PFont bold;

rocket player;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  noFill();
  stroke(255);
  strokeWeight(2);
  noSmooth();
  background(0);
  
  display=createFont("zx_spectrum-7.ttf",11);
  bold=createFont("zx_spectrum-7_bold.ttf",11);
  textFont(bold);
  textAlign(CENTER);
  
  player=new rocket(new PVector(width/2,height/2),0.06);
  
  restart(false);
}

void draw(){
  fill(0);
  noStroke();
  rectMode(CENTER);
  rect(width/2,height/2,width,height);
  stroke(255);
//  background(0);
  
  for(laser l : lasers){
    l.update();
    l.render();
  }
  lasers.removeAll(toRemove);
  
  for(asteroid a : rocks){
    a.update();
    a.render();
  }
  for(asteroid a : toSplit){
    a.split();
  }
  toSplit.clear();
  
  if(lives>0){
    movePlayer();
  }
  else{
    fill(255);
    textSize(64);
    text("You lose",width/2,height/2);
    textSize(32);
    text("Press SPACE to restart",width/2,height/2+30);
    textSize(32);
    text("Final score: "+score,width/2,height/2+15);
    noFill();
  }
  
  if(rocks.size()<=0){
    levelCounter--;
    if(levelCounter<240&&levelCounter>60){
      fill(255);
      textSize(32);
      text("LEVEL "+(level+1),width/2,height/2);
      noFill();
    }
    if(levelCounter<=0){
      restart(true);
    }
  }
}

void movePlayer(){
  if(inputs[0]==UP){
    pushMatrix();
    translate(player.location.x,player.location.y);
    PVector direction=PVector.fromAngle(radians(player.rotation));
    direction.setMag(player.thrust);
    player.applyForce(direction);
    popMatrix();
  }
  if(inputs[1]==LEFT){
    player.spin(-4);
  }
  if(inputs[2]==RIGHT){
    player.spin(4);
  }
  if(inputs[3]==DOWN){
    pushMatrix();
    translate(player.location.x,player.location.y);
    PVector direction=PVector.fromAngle(radians(player.rotation));
    direction.setMag(-player.thrust);
    player.applyForce(direction);
    popMatrix();
  }
  
  player.update();
  player.checkOutOfBounds();
  
  if(iframes>0){
    iframes--;
  }
  if(int(iframes/2)==iframes/2){
    player.render();
  }
  
  for(int i=1;i<lives;i++){
    pushMatrix();
    translate(40*i-20,height-22);
    triangle(20,0,-10,-10,-10,10);
    popMatrix();
  }
}

void restart(boolean isLevel){
  fill(255);
  text("Loading",width/2,height/2);
  noFill();
  
  for(int i=0;i<4;i++){
    inputs[i]=0;
  }
  
  player.location.set(width/2,height/2);
  lasers.clear();
  rocks.clear();
  
  if(isLevel){
    lives++;
    level++;
    for(int i=0;i<random(3+level,6+level);i++){
      rocks.add(new asteroid(new PVector(random(width),random(height)),PVector.random2D(),random(0.2,0.5),random(3),random(60*(level/10+1),100*(level/10+1)),false));
    }
  }
  else{
    lives=3;
    score=0;
    level=0;
  }
  
  player.velocity.mult(0);
  player.acceleration.mult(0);
  player.rotation=0;
  
  iframes=240;
  levelCounter=300;
}

void mousePressed(){
  if(lasers.size()<4&&lives>0){
    lasers.add(new laser(player.location.get(),PVector.fromAngle(radians(player.rotation)),10));
  }
}

void keyPressed(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          inputs[0]=UP;
          break;
        case LEFT:
          inputs[1]=LEFT;
          break;
        case RIGHT:
          inputs[2]=RIGHT;
          break;
        case DOWN:
          inputs[3]=DOWN;
          break;
      }
      break;
    case 'w':
    case 'W':
      inputs[0]=UP;
      break;
    case 'a':
    case 'A':
      inputs[1]=LEFT;
      break;
    case 'd':
    case 'D':
      inputs[2]=RIGHT;
      break;
    case 's':
    case 'S':
      inputs[3]=DOWN;
      break;
    case ' ':
      if(lasers.size()<4&&lives>0){
        lasers.add(new laser(player.location.get(),PVector.fromAngle(radians(player.rotation)),10));
      }
      else if(!(lives>0)){
        restart(false);
        lives++;
      }
      break;
  }
}

void keyReleased(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          inputs[0]=0;
          break;
        case LEFT:
          inputs[1]=0;
          break;
        case RIGHT:
          inputs[2]=0;
          break;
        case DOWN:
          inputs[3]=0;
          break;
      }
      break;
    case 'w':
    case 'W':
      inputs[0]=0;
      break;
    case 'a':
    case 'A':
      inputs[1]=0;
      break;
    case 'd':
    case 'D':
      inputs[2]=0;
      break;
    case 's':
    case 'S':
      inputs[3]=0;
      break;
  }
}

