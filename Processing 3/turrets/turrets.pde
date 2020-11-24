float laserX=random(610);
float laserY=random(450);
int pointX;
int pointY;
int countDown=60;
boolean hit=false;
int hitTimer=0;
float teslaX=random(610);
float teslaY=random(450);
float strokeRed;
float strokeGreen;
int teslaRange=100;
int noise=400;
float laserTracker;
int laserRange=400;

void setup(){
  size(640,480);
  stroke(255);
  cursor(CROSS);
}

void draw(){
  background(0);
  noFill();
  strokeRed=random(0,64);
  strokeGreen=random(0,191);
  
  ellipse(laserX,laserY,15,15);
  
  laserTracker=atan2(mouseY-laserY,mouseX-laserX);
  pushMatrix();
  translate(laserX,laserY);
  rotate(laserTracker);
  rect(0,0,30,0);
  popMatrix();
  
  ellipse(teslaX,teslaY,15,15);
  noStroke();
  fill(50,0,0,60);
  ellipse(teslaX,teslaY,teslaRange*2,teslaRange*2);
  stroke(255);
  noFill();
  
  if(hitTimer>0){
    hitTimer--;
    fill(255,0,0,150);
  }
  else{
    hit=false;
  }
  
  if(countDown==0){
    pushMatrix();
    translate(laserX,laserY);
    rotate(laserTracker);
    stroke(200,0,0);
    rect(0,0,laserRange,0);
    popMatrix();
    if(dist(pmouseX,pmouseY,mouseX,mouseY)<=15&&hitTimer==0){
      hit=true;
      hitTimer=120;
      fill(255,0,0,150);
    }
    countDown=round(random(40,90));
  }
  
  if(dist(mouseX,mouseY,teslaX,teslaY)<=teslaRange){
    noFill();
    stroke(strokeRed,strokeGreen,255);
    curve(random(-noise,noise),random(-noise,noise),teslaX,teslaY,mouseX,mouseY,random(-noise,noise),random(-noise,noise));
    hit=true;
    hitTimer=120;
    fill(255,0,0,150);
  }
  
  stroke(255);
  
  ellipse(mouseX,mouseY,15,15);
  
  fill(255);
  text("Mouse coordinates (X,Y): (" +mouseX+","+mouseY+")",4,15);
  text("Pmouse coordinates (X,Y): ("+pmouseX+","+pmouseY+")",4,30);
  text("Mouse coord difference: "+(round(dist(pmouseX,pmouseY,mouseX,mouseY))),4,45);
  text("Exact difference: "+dist(pmouseX,pmouseY,mouseX,mouseY),4,60);
  text("Laser coordinates: X: "+laserX+", Y: "+laserY,4,75);
  text("Count to next shot: "+countDown,4,90);
  text("Hit: "+hit,4,105);
  text("IFrames: "+hitTimer,4,120);
  text("Tesla coordinates: X: "+teslaX+", Y: "+teslaY,4,135);
  text("Tesla noise level: "+noise,4,150);
  text("Distance to tesla: "+dist(mouseX,mouseY,teslaX,teslaY),4,165);
  text("Tesla range: "+teslaRange,4,180);
  text("Laser angle: "+laserTracker,4,195);
  text("Laser range: "+laserRange,4,210);
  
  countDown--;
}

void keyPressed(){
  if(key=='l'||key=='L'){
    laserX=mouseX;
    laserY=mouseY;
  }else if(key=='t'||key=='T'){
    teslaX=mouseX;
    teslaY=mouseY;
  }
}


