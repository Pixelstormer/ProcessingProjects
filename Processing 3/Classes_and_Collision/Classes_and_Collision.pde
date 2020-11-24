MouseFollower follower;
PhysicsSquare phys;
TerrainRect terrain;

boolean force = false;

void setup(){
  size(840,560);
  surface.setResizable(true);
  
  follower = new MouseFollower();
  phys = new PhysicsSquare(
    new PVector(0,0),
    new PVector(width/2,height/2),
    new PVector(25,25),
    0.99,
    -1,
    1,
    false,
    false
  );
  terrain = new TerrainRect(new PVector(width/1.5,height/2), new PVector(200,140));
  
  background(0);
}

void draw(){
  background(0);
  
  follower.Update();
  follower.Render();
  
  phys.Render();
  if(force){
    phys.MovePoint(new PVector(mouseX,mouseY));
  }
  else{
    phys.IteratePhysics();
  }
  PVector CollisionResult = terrain.pollForBoundsCollision(phys.GetLocation(),phys.Bounds);
  phys.forceSetLocation(new PVector(CollisionResult.x,CollisionResult.y));
  phys.bounceVelocity(int(CollisionResult.z));
  phys.CheckScreenBounds();
  
  terrain.Render();
}

void mousePressed(){
  force = true;
}

void mouseReleased(){
  force = false;
}