int x;
int y;
int x_increment;
int y_velocity;
int gravity;

void setup(){
  size(840,560);
  frame.setResizable(true);
  background(230);
  fill(0);
  noStroke();
  set_values();
}

void set_values(){
  x = 1;
  y = 1;
  x_increment = 13;
  y_velocity = 32;
  gravity = 1;
}

void draw(){
  x+= x_increment;
  y_velocity -= gravity;
  y += y_velocity;
  ellipse(x,height-y,5,5);
}

void keyPressed(){
  set_values();
  background(230);
}

