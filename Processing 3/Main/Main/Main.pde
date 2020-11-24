float laserX=random(width);//Initial laser X coord
float laserY=random(height);//Initial laser Y cood
float laserXbuffer=mouseX;//Buffer for laser teleporting
float laserYbuffer=mouseY;//Buffer for laser teleporting
float teleChance;//Chance for laser to teleport upon firing
float teleThreshhold;//Threshhold for laser teleport chance
int countDown=60;//Handler for time between laser attacks - is actually randomly between 40 to 90
float charge=0;//For visual display of time until laser attacks
float trackX=mouseX;//For tracking-
float trackY=mouseY;//-Mouse location
float ease=0.1;//Speed of barrel rotation
int tempCount;//Temporary handler for laser turret cooldown
float laserAngle;//Angle of laser turret barrel

boolean hit=false;//If hit, is true
int hitTimer=0;//Number of Iframes remaining
int damage=0;//'Damage' taken
int tempHealth=100;//Temporary handler for health before being passed to main 'health' variable
String health=""+tempHealth;//Maximum damage before 'dying'
float targX;
float targY;
PFont deathFont;

float teslaX=random(20,width-20);//Initial tesla X coord
float teslaY=random(20,height-20);//Initial tesla Y coord
float Xspeed=2.8;//Tesla's X velocity
float Yspeed=2.8;//Tesla's Y velocity
int Xdirection=1;//Whether tesla is moving left or right
int Ydirection=1;//Whether tesla is moving up or down
float strokeRed;//Tesla arc red colour
float strokeGreen;//Tesla arc green colour
int teslaRange=200;//Tesla's range
int noise=350;//Noise of tesla's arcs

ArrayList<Rocket> shooter;
ArrayList<Rocket> toRemove=new ArrayList<Rocket>();
PImage rocket;

void setup(){
  size(840,680);
  stroke(255);
  noCursor();
  deathFont=loadFont("BNMachine-48.vlw");
  imageMode(CENTER);
  rocket=loadImage("rocket.gif");
  surface.setResizable(true);
  shooter=new ArrayList<Rocket>();
}

void draw(){
  noStroke();
    fill(0,100);
    rect(0,0,width,height);
  if(tempHealth<=0){
    tempHealth=0;
    health="DEAD";
  }
  fill(255);
  textAlign(RIGHT);
  text("Health: "+health,width-4,15);
 
  if(hitTimer>0){
    hitTimer--;
    fill(255,0,0,150);
  }
  else{
    hit=false;
    noFill();
    teleThreshhold=40;
  }
  
    stroke(255);
    strokeWeight(0.5);
  if(health!="DEAD"){
    targX=mouseX;
    targY=mouseY;
  }else{
    pushStyle();
    fill(255,0,0);
    textAlign(CENTER);
    textSize(64);
    textFont(deathFont);
    text("DEAD",width/2,height/2);
    popStyle();
  }
  ellipse(targX,targY,1,1);
  ellipse(targX,targY,15,15);
  
  teslaHandler();
  
  laserHandler();
  
  ellipse(width/2,height/2,map(frameCount%120,0,120,-15,15),map(frameCount%120,0,120,-15,15));
  if(frameCount%120==0){
    shooter.add(new Rocket(18,0.4,350,1.03,120,40));
  }
  
  for(Rocket r : shooter){
    if(r.primed()>r.explodetime){
      r.update();
      r.display();
    }else{
      r.detonate();
    }
    if(r.primed()<=0||r.life>600){
      toRemove.add(r);
    }
  }
  shooter.removeAll(toRemove);
  
  debug();
}

void keyPressed(){
  if(key=='l'||key=='L'){//Moves laser turret to current mouse position
    laserXbuffer=mouseX;
    laserYbuffer=mouseY;
  }else if(key=='t'||key=='T'){//Moves tesla turret to current mouse position
    teslaX=mouseX;
    teslaY=mouseY;
  }else if(key=='d'||key=='D'){//Toggles debug info
    debug=!debug;
  }else if(key=='r'||key=='R'){
    shooter.add(new Rocket(18,0.4,350,1.03,120,40));
  }
}

void hit(int taken){
  damage+=taken;//Still records damage taken even though heath doesn't deplete
  if(!debug){//Debug mode turns you invincible
    //Handles being hit
    hit=true;
    hitTimer=120;
    teleThreshhold+=taken;
    tempHealth-=taken;
    health=""+tempHealth;
  }
}

boolean overCircle(float circX, float circY, int diameter) {
  float disX = circX - targX;
  float disY = circY - targY;
  if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}