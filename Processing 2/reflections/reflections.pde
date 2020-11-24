PVector ray;
PVector direction;
PVector originalDirection;
PVector origin;
float speed=1;
int limit=200;
boolean moveOrigin;
boolean rotateOrigin;

ArrayList<mirror> mirrors=new ArrayList<mirror>();

void setup() {
  size(840, 560);
  frame.setResizable(true);

  origin=new PVector(width/2, height/2);
  ray=origin.get();
  originalDirection=PVector.sub(new PVector(width/2, height), ray);

  mirrors.add(new mirror(new PVector(width/2-25, height-55), new PVector(width/2+25, height-5)));
  mirrors.add(new mirror(new PVector(width-25,height-55),new PVector(width-75,height-5)));
  mirrors.add(new mirror(new PVector(width-75,height/2-25),new PVector(width-25,height/2+25)));
  mirrors.add(new mirror(new PVector(width/2+25,height/2-35),new PVector(width/2-35,height/2+25)));
  
  noStroke();
  fill(255);
}

void draw() {
  background(0);

  for (mirror m : mirrors) {
    if (m.leftDragged) {
      m.mirrorLeft.set(mouseX, mouseY);
      m.move();
    }
    if (m.rightDragged) {
      m.mirrorRight.set(mouseX, mouseY);
      m.move();
    }
    m.update();
  }

  if (moveOrigin) {
    origin.set(mouseX, mouseY);
  }
  else if(rotateOrigin){
    originalDirection=PVector.sub(new PVector(mouseX,mouseY),origin);
  }
  
  ray=origin.get();
  direction=originalDirection.get();
  direction.setMag(speed);

  int bounces=0;
  while (! (isOutOfBounds (ray.x, ray.y, 5, 5))) {
    ray.add(direction);

    PVector incidence=PVector.mult(direction, -1);
    incidence.normalize();

    for (mirror m : mirrors) {
      for (int i=0; i<m.points.length; i++) {
        if (PVector.dist(ray, m.points[i]) < 5) {
          float dot=incidence.dot(m.normal);

          direction.set(2*m.normal.x*dot - incidence.x, 2*m.normal.y*dot - incidence.y, 0);
          direction.setMag(speed);
          bounces++;
        }
      }
    }

    if (bounces>=limit) {
      break;
    }

    fill(255, 200-bounces);
    noStroke();
    ellipse(ray.x, ray.y, 5, 5);
  }

  for (mirror m : mirrors) {
    m.render();
  }
}

boolean overCircle(float x, float y, float diameter) {
  return sqrt(sq(x-mouseX)+sq(y-mouseY))<diameter/2;
}

boolean overRect(float posX,float posY,float x, float y, float width, float height)  {
  return posX<x+width/2 && posX>x-width/2 && posY<y+height/2 && posY>y-height/2;
}

boolean isOutOfBounds(float x, float y, float Width, float Height) {
  return x>width+Width||x<0-Width||y>height+Height||y<0-Height;
}

void mousePressed() {
  switch(mouseButton) {
  case LEFT:
    if (overCircle(origin.x, origin.y, 15)) {
      moveOrigin=true;
      break;
    }
    if(overCircle(origin.x,origin.y,25)){
      rotateOrigin=true;
      break;
    }
    for (mirror m : mirrors) {
      if (overCircle(m.mirrorLeft.x, m.mirrorLeft.y, 15)) {
        m.leftDragged=true;
        break;
      } else if (overCircle(m.mirrorRight.x, m.mirrorRight.y, 15)) {
        m.rightDragged=true;
        break;
      }
    }
    break;
  case RIGHT:
    boolean place=true;
    ArrayList<mirror> toRemove=new ArrayList<mirror>();
    for (mirror m : mirrors) {
      if(!(place)){
        break;
      }
      for (int i=0; i<m.points.length; i++) {
        if (PVector.dist(new PVector(mouseX,mouseY), m.points[i]) < 5) {
          toRemove.add(m);
          place=false;
        }
      }
    }
    mirrors.removeAll(toRemove);
    if(place){
      mirrors.add(new mirror(new PVector(mouseX-25, mouseY), new PVector(mouseX+25, mouseY)));
    }
    break;
  }
}

void mouseReleased() {
  for (mirror m : mirrors) {
    m.leftDragged=false;
    m.rightDragged=false;
  }
  moveOrigin=false;
  rotateOrigin=false;
}

