class atom{
  float blueY,redY,greenY1,greenY2;
  float angle1, angle2,ang,ang1,ang2,angle;
  float scalar;
  float rotate;
  float x,baseY;
  float rSpeed,mSpeed;
  
  boolean drawR,drawB,drawG,drawC;
  
  atom(float scalar_,float rSpeed_,float mSpeed_,float baseY_,boolean drawR_,boolean drawB_,boolean drawG_,boolean drawC_){
    scalar=scalar_;
    rSpeed=rSpeed_;
    mSpeed=mSpeed_;
    
    baseY=baseY_;
    
    drawR=drawR_;
    drawB=drawB_;
    drawG=drawG_;
    drawC=drawC_;
  }
  
  void update(){
    
    ang1 = radians(angle1);
    ang2 = radians(angle2);
    
    angle=radians(ang);
    
    greenY1=0+(scalar*sin(angle));
    greenY2=0-(scalar*sin(angle));
    blueY = 0 + (scalar * sin(ang1));
    redY = 0 - (scalar * sin(ang2));
    
    pushMatrix();
    translate(x,greenY1+baseY);
    
    rotate(radians(rotate));
    
    if(drawB){    
      fill(0,0,255);
      ellipse(0, blueY, 3, 3);
    }
    
    if(drawR){
      fill(255,0,0);
      ellipse(0, redY, 3, 3);
    }
    
    popMatrix();
    
    if(drawG){
      pushMatrix();
      translate(x,baseY);
      rotate(radians(rotate));
      
      fill(0,255,0);
      ellipse(0,greenY1,6,6);
      popMatrix();
    }
    
    pushMatrix();
    translate(x,greenY2+baseY);
    
    rotate(radians(rotate));
    
    if(drawR){
      fill(255,0,0);
      ellipse(0,blueY,3,3);
    }
    if(drawB){
      fill(0,0,255);
      ellipse(0,redY,3,3);
    }
    
    popMatrix();
    
    if(drawG){
      pushMatrix();
      translate(x,baseY);
      rotate(radians(rotate));
    
      fill(0,255,0);
      ellipse(0,greenY2,6,6);
      popMatrix();
    }
    
    if(drawC){
      pushMatrix();
      translate(x,baseY);
      
      fill(255);
      ellipse(0,0,9,9);
      popMatrix();
    }
  
    angle1 += 8;
    angle2 += 8;
    ang+=6;
    
    rotate-=rSpeed;
    
    if(x>width){
      x=0;
    }else{
      x+=mSpeed;
    }
  }
}
