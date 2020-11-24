Path path=new Path();
ArrayList<Vehicle> vehicles=new ArrayList<Vehicle>();
ArrayList<Vehicle> toRemove=new ArrayList<Vehicle>();
String mode="placePath";
int speed=3;

ArrayList<button> menu=new ArrayList<button>();
boolean menuVisible=false;

PImage pathSprite;
PImage vehicleSprite;
PImage noPathSprite;
PImage noVehicleSprite;

void setup() {
  size(840, 560);
  frame.setResizable(true);

  textAlign(LEFT, TOP);
  text("Loading", width/2, height/2);

  path.addPoint(width/2-45, height/2-45);
  path.addPoint(width/2-45, height/2+45);
  path.addPoint(width/2+45, height/2+45);
  path.addPoint(width/2+45, height/2-45);
  path.addPoint(width/2-45, height/2-45);

  vehicles.add(new Vehicle(2, width/2-45, height/2-45));

  pathSprite=loadImage("pathSprite.png");
  vehicleSprite=loadImage("vehicleSprite.png");
  noPathSprite=loadImage("noPathSprite.png");
  noVehicleSprite=loadImage("noVehicleSprite.png");

  menu.add(new button(2.8, 55.25, true, "placeVehicles", vehicleSprite));
  menu.add(new button(7.5, 55.25, true, "placePath", pathSprite));
  menu.add(new button(7.5, 55.25, false, "removePath", noPathSprite));
  menu.add(new button(2.8, 55.25, false, "removeVehicles", noVehicleSprite));
}

void draw() {
  background(0);
  path.render();
  for (Vehicle v : vehicles) {
    v.followPath();
    v.render();
  }

  renderMenu();
}

void removeAll() {
  for (Vehicle v : vehicles) {
    toRemove.add(v);
  }

  vehicles.removeAll(toRemove);
}

void renderMenu() {
  if (menuVisible) {
    fill(#0561A5);
    rect(width/2-(width/1.2)/2, height-72.5, width/1.2, 145);

    fill(#0A78C4);
    rect(width/2-25, height-87.5, 50, 15);

    noStroke();
    fill(#065389);
    pushMatrix();
    translate(width/2, height-80);
    beginShape(PConstants.TRIANGLES);
    vertex(0, 6);
    vertex(-6*2, -6);
    vertex(6*2, -6);
    endShape();
    popMatrix();

    for (button b : menu) {
      b.render();
    }
  } else {
    fill(#0A78C4);
    rect(width/2-25, height-15, 50, 30);

    noStroke();
    fill(#065389);
    pushMatrix();
    translate(width/2, height-7);
    beginShape(PConstants.TRIANGLES);
    vertex(0, -6);
    vertex(-6*2, 6);
    vertex(6*2, 6);
    endShape();
    popMatrix();
  }
}

boolean toggleMenu() {
  if (!(menuVisible)&&overRect(width/2-25, height-15, 50, 30)) {
    menuVisible=!(menuVisible);
  } else if (menuVisible&&overRect(width/2-25, height-87.5, 50, 15)) {
    menuVisible=!(menuVisible);
  } else {
    return false;
  }
  return true;
}

void pressButtons() {
  for (button b : menu) {
    b.checkPressed();
  }
  if(mode=="placeVehicles"){
    if(overRect(menu.get(0).getX()+35.5,menu.get(0).getY()-24.5,17,18)){
      speed++;
    }
    else if (overRect(menu.get(0).getX()+50.5,menu.get(0).getY()-24.5, 17, 18)&&speed>0) {
      speed--;
    }
  }
}

void clickAction() {
  if (mode=="placePath") {
    path.addPoint(mouseX, mouseY);
  } else if (mode=="placeVehicles"&&path.points.size()>0) {
    vehicles.add(new Vehicle(speed, mouseX, mouseY));
  } else if (mode=="removePath") {
    path.removePoint(mouseX, mouseY);
  } else if (mode=="removeVehicles") {
    removeVehicle();
  }
}

void removeVehicle() {
  PVector mouse=new PVector(mouseX, mouseY);
  float dist=40;
  int closestIndex= -1;
  for (int i=0;i<vehicles.size(); i++) {
    if (mouse.dist(vehicles.get(i).location)<dist) {
      closestIndex=i;
      dist=mouse.dist(vehicles.get(i).location);
    }
  }
  try {
    vehicles.remove(closestIndex);
  }
  catch(IndexOutOfBoundsException e) {
  }
}

boolean overRect(float x, float y, float width, float height) {
  return mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height;
}

boolean overCircle(int x, int y, int diameter) {
  return sqrt(sq(x - mouseX) + sq(y - mouseY)) < diameter/2;
}

void mouseReleased() {
  switch(mouseButton) {
  case LEFT:
    if (!(toggleMenu())&&(!(overRect(width/2-(width/1.2)/2, height-72.5, width/1.2, 145))||!(menuVisible))&&!(mode=="placeVehicles"&&overRect(menu.get(0).getX()-22.5, menu.get(0).getY()-27.5, 90, 22.5))) {
      clickAction();
    } else if (menuVisible) {
      pressButtons();
    }
  }
}

