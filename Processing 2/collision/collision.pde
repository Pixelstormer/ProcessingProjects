import java.util.List;

final PVector gravity = new PVector(0, 1);

List<? extends Rigidbody> rigidBodies;
List<? extends Staticbody> staticBodies;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  rigidBodies = new ArrayList<Rigidbody>();
  staticBodies = new ArrayList<Staticbody>();
}

void draw(){
  background(0);
  
  for(Staticbody body : staticBodies){
    body.render();
  }
  
  for(Rigidbody body : rigidBodies){
    body.virtualUpdate(staticBodies, rigidBodies);
  }
  
  for(Rigidbody body : rigidBodies){
    body.applyVirtualUpdates();
    body.render();
  }
}

