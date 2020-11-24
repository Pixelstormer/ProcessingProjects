import java.util.Set;
import java.util.List;
import java.util.Map.Entry;

PVector origin;
PVector head;
PVector velocity;

final float HEAD_WEIGHT = 1;
final float DRAG_FORCE = 1;
final float PULL_FORCE = 1;
final float HEAD_LENGTH = 200;
final PVector GRAVITY = new PVector(0,1);

final float LINE_SCALAR = 5;
final float FORCE_SCALAR = 30;

final PVector RED = new PVector(255,0,0);
final PVector GREEN = new PVector(0,255,0);
final PVector BLUE = new PVector(0,0,255);
final PVector WHITE = new PVector(255,255,255);

HashMap<String,DebugLine> debugLines;
List<String> AUTO_UPDATED = new ArrayList<String>();

void setup(){
  size(840,560);
  //frame.setResizable(true);
  
  debugLines = new HashMap<String,DebugLine>();
  
  origin = new PVector(width/2,height/2);
  head = new PVector(width/2-HEAD_LENGTH,height/2);
  
  velocity = new PVector(0,0);
  
  registerDebugLines();
}

void draw(){
  background(0);
  
  origin.set(width/2,height/2);
  
  //Accumulate the total acceleration due to outside forces in this vector
  PVector acceleration = new PVector(0,0);
  acceleration.add(PVector.mult(GRAVITY,HEAD_WEIGHT));
  
  if(mousePressed){
    PVector mouse = new PVector(mouseX,mouseY);
    PVector dir = PVector.sub(mouse,head);
    dir.setMag(PULL_FORCE);
    acceleration.add(dir);
  }
  
  //Apply acceleration and drag
  velocity.add(acceleration);
  velocity.mult(DRAG_FORCE);
  
  //Correct velocity to maintain constant distance from pivot
  PVector newPosition = PVector.add(velocity,head);
  PVector difference = PVector.sub(origin,newPosition);
  float newDistance = PVector.dist(newPosition,origin);
  difference.setMag(-HEAD_LENGTH+newDistance);
  velocity.add(difference);
  debugLines.get("CORRECTION").update(difference);
  
  //Apply velocity
  head.add(velocity);
  
  //Render, passing in a calculated vector for debug lines
  render(difference);
  renderDebug();
}

void render(PVector difference){
  stroke(255);
  strokeWeight(5);
  line(origin.x,origin.y,head.x,head.y);
  noStroke();
  fill(255);
  ellipse(head.x,head.y,15,15);
  
  strokeWeight(2);
  stroke(255);
  noFill();
  ellipse(origin.x,origin.y,HEAD_LENGTH*2+abs(PVector.mult(GRAVITY,HEAD_WEIGHT).mag()),HEAD_LENGTH*2+abs(PVector.mult(GRAVITY,HEAD_WEIGHT).mag()));
  
//  PVector scaledVelocity = PVector.add(PVector.mult(velocity,LINE_SCALAR),head);
//  PVector scaledGravity = PVector.add(PVector.mult(GRAVITY,FORCE_SCALAR),head);
//  PVector scaledDifference = PVector.add(PVector.mult(difference,FORCE_SCALAR),scaledVelocity);
//  PVector scaledPull = PVector.add(PVector.mult(PVector.sub(new PVector(mouseX,mouseY),head).normalize(null),(mousePressed)?FORCE_SCALAR:0),head);
//  stroke(0,0,255);
//  line(head.x,head.y,scaledVelocity.x,scaledVelocity.y);
//  stroke(255,0,0);
//  line(head.x,head.y,scaledGravity.x,scaledGravity.y);
//  line(head.x,head.y,scaledPull.x,scaledPull.y);
//  stroke(0,255,0);
//  line(scaledVelocity.x,scaledVelocity.y,scaledDifference.x,scaledDifference.y);
}

void renderDebug(){
  for(Entry<String,DebugLine> entry : debugLines.entrySet()){
    if(AUTO_UPDATED.contains(entry.getKey())) entry.getValue().update();
    entry.getValue().render();
  }
}

void stroke(PVector colour){
  stroke(colour.x,colour.y,colour.z);
}

void fill(PVector colour){
  fill(colour.x,colour.y,colour.z);
}

void registerDebugLines(){
  //Gravity
  debugLines.put("GRAVITY",new DebugLine(RED,head,GRAVITY,HEAD_WEIGHT*FORCE_SCALAR));
  AUTO_UPDATED.add("GRAVITY");
  
  //Velocity
  debugLines.put("VELOCITY",new DebugLine(BLUE,head,velocity,LINE_SCALAR));
  AUTO_UPDATED.add("VELOCITY");
  
  //Distance correction
  debugLines.put("CORRECTION",new DebugLine(GREEN,debugLines.get("VELOCITY").endPoint,GRAVITY,FORCE_SCALAR));
}
