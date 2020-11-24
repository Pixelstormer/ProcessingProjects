import java.util.List;
import java.lang.Cloneable;
import java.util.Map.Entry;
import java.util.AbstractMap.SimpleEntry;
import java.util.Set;

Skeleton worm;

BoundingBox screenBounds;

float pullForce = 512;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  screenBounds = new BoundingBox(width-4, height-4, width/2, height/2, 0.9999);
  
  PVector gravity = new PVector(0, 0.4);
  
  float mass = 6;
  float drag = 0.1;
  float friction = 0.1;
  boolean hasG = true;
  float k = 12;
  float eq = 32;
  
  worm = new Skeleton();
  worm.addJoint(new PVector(width/2, height/2), mass, drag, friction, gravity, hasG, k, eq);
  worm.addJoint(new PVector(width/2+32, height/2), mass, drag, friction, gravity, hasG, k, eq);
  worm.addJoint(new PVector(width/2+64, height/2), mass, drag, friction, gravity, hasG, k, eq);
  worm.addJoint(new PVector(width/2+15, height/2-16), mass, drag, friction, gravity, hasG, k, eq);
  worm.addJoint(new PVector(width/2+33, height/2-16), mass, drag, friction, gravity, hasG, k, eq);
  worm.addJoint(new PVector(width/2+32, height/2-17), mass, drag, friction, gravity, hasG, k, eq);
  
  worm.addConnection(3, 1, k, eq);
  worm.addConnection(3, 4, k, eq);
  worm.addConnection(4, 2, k, eq);
  worm.addConnection(5, 3, k, eq);
}

void draw(){
  background(0);
  
  if(mousePressed){
    for(int i=0; i<worm.jointAmount(); i++){
      PVector force = PVector.mult(PVector.sub(new PVector(mouseX, mouseY), worm.getJoint(i).position()).normalize(null), pullForce);
      worm.applyForce(i, force);
    }
  }
  
  worm.updateAll();
  worm.render();
}

