// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Path Following
// Via Reynolds: // http://www.red3d.com/cwr/steer/PathFollow.html

// Using this variable to decide whether to draw all the stuff
boolean debug = false;

// A path object (series of connected points)
Path path;

// Two vehicles
Vehicle car1;
Vehicle car2;

car player;
StringList inputBuffer=new StringList();

void setup() {
  size(640, 360);
  frame.setResizable(true);
  
  // Call a function to generate new Path object
  newPath();

  // Each vehicle has different maxspeed and maxforce for demo purposes
  car1 = new Vehicle(new PVector(0, height/2), 8, 2);
  car2 = new Vehicle(new PVector(0, height/2), 24, 0.2);
  player=new car(width/2, height/2);
}

void draw() {
  background(255);
  // Display the path
  path.display();
  // The boids follow the path
  car1.follow(path);
  car2.follow(path);
  // Call the generic run method (update, borders, display, etc.)
  car1.run();
  car2.run();

  car1.borders(path);
  car2.borders(path);

  doInputs();
  player.move();
  player.render();

  // Instructions
  fill(0);
  text("Hit space bar to toggle debugging lines.\nClick the mouse to generate a new path.", 10, height-30);
}

void newPath() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  path = new Path();
  path.addPoint(-20, random(height));
  path.addPoint(random(0, width/2), random(0, height));
  path.addPoint(random(width/2, width), random(0, height));
  path.addPoint(width+20, random(height));
}

void doInputs() {
  if (inputBuffer.hasValue("UP")) {
    player.speed+=0.2;
  }
  if (inputBuffer.hasValue("LEFT")) {
    player.rotation-=3;
    player.applyDrag(0.05);
  }
  if (inputBuffer.hasValue("RIGHT")) {
    player.rotation+=3;
    player.applyDrag(0.05);
  }
  if (inputBuffer.hasValue("DOWN")) {
    player.speed-=0.2;
  }
}

void keyPressed() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:
      inputBuffer.set(0, "UP");
      break;
    case RIGHT:
      inputBuffer.set(1, "RIGHT");
      break;
    case LEFT:
      inputBuffer.set(2, "LEFT");
      break;
    case DOWN:
      inputBuffer.set(3, "DOWN");
      break;
    }
    break;
  case 'w':
  case 'W':
    inputBuffer.set(0, "UP");
    break;
  case 'd':
  case 'D':
    inputBuffer.set(1, "RIGHT");
    break;
  case 'a':
  case 'A':
    inputBuffer.set(2, "LEFT");
    break;
  case 's':
  case 'S':
    inputBuffer.set(3, "DOWN");
    break;
  }
}

void keyReleased() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:
      inputBuffer.set(0, null);
      break;
    case RIGHT:
      inputBuffer.set(1, null);
      break;
    case LEFT:
      inputBuffer.set(2, null);
      break;
    case DOWN:
      inputBuffer.set(3, null);
      break;
    }
    break;
  case 'w':
  case 'W':
    inputBuffer.set(0, null);
    break;
  case 'd':
  case 'D':
    inputBuffer.set(1, null);
    break;
  case 'a':
  case 'A':
    inputBuffer.set(2, null);
    break;
  case 's':
  case 'S':
    inputBuffer.set(3, null);
    break;
  case ' ':
    debug=!(debug);
  }
}

public void mousePressed() {
  newPath();
}

