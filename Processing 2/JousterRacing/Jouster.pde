class Jouster{
  PVector location;
  PVector velocity;
  PVector targetLocation;
  PVector targetVelocity;
  float turnSpeed;
  float moveSpeed;
  float targetTimeoutTimer;
  float targetTimeoutTheshhold;
  float oldD;
  int targetLocIndex;
  int score;
  
  Jouster(PVector initLoc,PVector initVel,float TurnSpeed,float MoveSpeed, float timeoutTheshhold){
    location = initLoc.get();
    velocity = initVel.get();
    velocity.setMag(MoveSpeed);
    targetLocation = new PVector(0,0);
    targetVelocity = new PVector(0,0);
    turnSpeed = TurnSpeed;
    moveSpeed = MoveSpeed;
    targetTimeoutTimer = 0;
    targetTimeoutTheshhold = timeoutTheshhold;
    oldD = 0;
    targetLocIndex = 0;
    score = 0;
  }
  
  void move(){
    //Update target velocity
    PVector targetVelocity = PVector.sub(location,targetLocations[targetLocIndex]);
    
    //Calculate which side target is on relative to velocity
    float d = (targetLocations[targetLocIndex].x-location.x)
             *((location.y+velocity.y)-location.y)
             -(targetLocations[targetLocIndex].y-location.y)
             *((location.x+velocity.x)-location.x);
    
    int dSign = 0;
    int oldDSign = 0;
    
    if(d>0){
      dSign = 1;
    }
    if(d<0){
      dSign = -1;
    }
    if(d==0){
      dSign = 0;
    }
    
    if(oldD>0){
      oldDSign = 1;
    }
    if(oldD<0){
      oldDSign = -1;
    }
    if(oldD==0){
      oldDSign = 0;
    }
    
    if(oldDSign!=dSign){
      targetTimeoutTimer = 0;
      oldD = d;
    }
    else{
      targetTimeoutTimer++;
    }
    
    if(targetTimeoutTimer>=targetTimeoutTheshhold){
      updateNewTarget(targetLocIndex);
      targetTimeoutTimer = 0;
      oldD = d;
    }
    
    //Turn in the appropriate direction
    if(d<0){
      velocity.rotate(radians(-turnSpeed));
    }
    else if(d>0){
      velocity.rotate(radians(turnSpeed));
    }
    else if(d==0){
      velocity = targetVelocity.get();
      velocity.setMag(moveSpeed);
    }
    
    //If velocity is really close to target velocity, set directly to target velocity
    if(degrees(PVector.angleBetween(velocity,targetVelocity))<=turnSpeed+0.1){
      velocity = targetVelocity.get();
      velocity.setMag(moveSpeed);
    }
    
    //Avoid weird behaviour from exactly matching values
    velocity.add(new PVector(random(-0.2,0.2),random(-0.2,0.2)));
    
    //Sub instead of add to move forward because reasons
    location.sub(velocity);
    
    for(int i=0;i<targets;i++){
      if(PVector.dist(location,targetLocations[i])<targetSize){
        targetLocations[i] = new PVector(random(width),random(height));
        score++;
        if(i==targetLocIndex){
          updateNewTarget(-1);
        }
      }
    }
  }
  
  void updateTarget(PVector newTarget){
    targetLocations[targetLocIndex] = newTarget.get();
  }
  
  void moveTarget(PVector offset){
    targetLocations[targetLocIndex].add(offset);
  }
  
  void updateNewTarget(int ignoredIndex){
    float minDist = 9999;
    for(int i=0;i<targets;i++){
      if(PVector.dist(targetLocations[i],location)<minDist && i!=ignoredIndex){
        targetLocIndex = i;
        minDist = PVector.dist(targetLocations[i],location);
      }
    }
  }
  
  void render(){
    pushMatrix();
    translate(location.x,location.y);
    textSize(15);
    textAlign(CENTER,CENTER);
    text(score,0,-20);
    rotate(velocity.heading() + radians(-90));
    triangle(0,-10,5,10,-5,10);
    popMatrix();
  }
}

