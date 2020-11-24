class Player extends Unit implements ICanMoveMyself{
  
  int speed;
  int maximumSpeed;
  int shootCooldown;
  
  Player(PVector origin){
    super(origin, 0.4, 1);
    speed = 4;
    maximumSpeed = 7;
    shootCooldown = 10;
  }
  
  PVector inputDirectionVector(){
    PVector direction = new PVector(0,0);
    
    if(getInput('w')){
      direction.y--;
    }
    
    if(getInput('a')){
      direction.x--;
    }
    
    if(getInput('s')){
      direction.y++;
    }
    
    if(getInput('d')){
      direction.x++;
    }
    
    return direction.normalize(null);
  }
  
  @Override
  void render(){
    stroke(255);
    fill(0);
    strokeWeight(4);
    ellipse(position.x,position.y,15,15);
  }
  
  @Override
  void move(){
    applyForce(PVector.mult(inputDirectionVector(), speed));
    applyDrag();
    velocity.limit(maximumSpeed);
    applyVelocity();
  }
  
  void shoot(){
    shootCooldown--;
    if(getInput(LEFT) && shootCooldown <= 0){
      projectiles.add(new Projectile(position.get(), PVector.sub(new PVector(mouseX, mouseY), position.get())));
      shootCooldown = 10;
    }
  }
}

