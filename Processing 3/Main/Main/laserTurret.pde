void laserHandler(){
  //Declares all the variables
  trackX=lerp(trackX,targX,ease);
  trackY=lerp(trackY,targY,ease);
  PVector tracker=new PVector(trackX,trackY);
  PVector pointer=new PVector(laserX,laserY);
  PVector mouse=new PVector(targX,targY);
  laserAngle=PVector.angleBetween(tracker,mouse);
  
  tracker.sub(pointer);
  tracker.normalize();
  tracker.mult(40);
  
  laserX=lerp(laserX,laserXbuffer,0.2);
  laserY=lerp(laserY,laserYbuffer,0.2);
  
  pushMatrix();
  translate(laserX,laserY);
  stroke(100,200);
  
  if(countDown==0){
    stroke(200,0,0);
    strokeWeight(2);
      if(laserAngle<=0.0135&&hitTimer==0){
      hit(20);
    }
    tempCount=round(random(40,90));
    countDown=tempCount;
    charge=0;
    teleChance=random(100);
    if(teleChance>=teleThreshhold){
      laserXbuffer=random(610);
      laserYbuffer=random(450);
    }
  }
  charge=255-map(countDown,1,tempCount,1,255);
  countDown--;
  
  //Renders the barrel and laser
  line(0,0,tracker.x*width,tracker.y*width);
  stroke(255);
  strokeWeight(2);
  line(0,0,tracker.x,tracker.y);
  
  popMatrix();
  strokeWeight(1);
  
  if(abs(laserXbuffer-laserX)>=2&&abs(laserYbuffer-laserY)>=2){
    ellipse(laserXbuffer,laserYbuffer,15,15);
    stroke(strokeRed,strokeGreen,255);
    curve(random(-100,100),random(-100,100),laserX,laserY,laserXbuffer,laserYbuffer,random(-100,100),random(-100,100));
  }
  
  //Renders the turret body
  stroke(255);
  fill(charge,0,0);
  ellipse(laserX,laserY,15,15);
  noFill(); 
}