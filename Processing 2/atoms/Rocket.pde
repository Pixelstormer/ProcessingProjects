class Rocket{
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector target=new PVector(mouseX,mouseY);
  float topSpeed;
  float Acceleration;
  float range;
  boolean primed=false;
  float drag;
  int timer;
  int explodetime;
  int lifetime=0;
  int maxLifeTime;
  
  float blueY,redY,greenY1,greenY2;
  float angle1, angle2,ang,ang1,ang2,angle;
  float scalar;
  float rotate;
  float rSpeed,mSpeed;
  boolean drawR,drawB,drawG,drawC;
  int cD,gD,brD;
  
  Rocket(float speed,float acceleration_,float range_,float drag_,int timer_,int explodetime_,int maxLifeTime_,//Rocket stuff
         float scalar_,float rSpeed_,float mSpeed_,boolean drawR_,boolean drawB_,boolean drawG_,boolean drawC_,int cd,int gd,int brd){//Atom stuff
    location=new PVector(width/2,height/2);
    velocity= PVector.random2D();
    velocity.mult(100);
    topSpeed=speed;
    Acceleration=acceleration_;
    range=range_;
    drag=drag_;
    timer=timer_;
    explodetime=explodetime_;
    maxLifeTime=maxLifeTime_;
    
    scalar=scalar_;
    rSpeed=rSpeed_;
    mSpeed=mSpeed_;
    drawR=drawR_;
    drawB=drawB_;
    drawG=drawG_;
    drawC=drawC_;
    cD=cd;
    gD=gd;
    brD=brd;
  }
  
  int primed(){
    if(primed){
      timer--;
    }
    return timer;
  }
  
  void update(){
    target=new PVector(mouseX,mouseY);
    PVector acceleration=PVector.sub(target,location);
    acceleration.setMag(Acceleration);
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    velocity.div(drag);
    location.add(velocity);
    
    if(location.dist(target)<=range){
      primed=true;
    }
    lifetime++;
  }
  
  void display(){
    ang1 = radians(angle1);
    ang2 = radians(angle2);
    
    angle=radians(ang);
    
    greenY1=0+(scalar*sin(angle));
    greenY2=0-(scalar*sin(angle));
    blueY = 0 + (scalar * sin(ang1));
    redY = 0 - (scalar * sin(ang2));
    
    pushMatrix();
    translate(location.x,greenY1+location.y);
    
    rotate(radians(rotate));
    
    if(drawB){    
      fill(0,0,255);
      ellipse(0, blueY, brD, brD);
    }
    
    if(drawR){
      fill(255,0,0);
      ellipse(0, redY, brD, brD);
    }
    
    popMatrix();
    
    if(drawG){
      pushMatrix();
      translate(location.x,location.y);
      rotate(radians(rotate));
      
      fill(0,255,0);
      ellipse(0,greenY1,gD,gD);
      popMatrix();
    }
    
    pushMatrix();
    translate(location.x,greenY2+location.y);
    
    rotate(radians(rotate));
    
    if(drawR){
      fill(255,0,0);
      ellipse(0,blueY,brD,brD);
    }
    if(drawB){
      fill(0,0,255);
      ellipse(0,redY,brD,brD);
    }
    
    popMatrix();
    
    if(drawG){
      pushMatrix();
      translate(location.x,location.y);
      rotate(radians(rotate));
    
      fill(0,255,0);
      ellipse(0,greenY2,gD,gD);
      popMatrix();
    }
    
    if(drawC){
      pushMatrix();
      translate(location.x,location.y);
      
      fill(255);
      ellipse(0,0,cD,cD);
      popMatrix();
    }
  
    angle1 += 8;
    angle2 += 8;
    ang+=6;
    
    rotate-=rSpeed;
  }
  
  void detonate(){
    fill(200,100,0,map(timer,explodetime,0,255,0));
    noStroke();
    ellipse(location.x,location.y,range*4,range*4);
  }
}

