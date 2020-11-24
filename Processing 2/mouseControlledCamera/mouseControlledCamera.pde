final float baseSize = 50;
final PVector basePos = new PVector(420, 280);
PVector offset = new PVector(0, 0);
float scalar = 1;
float scaleFactor = 0.1;
float scaleMin = 0.2;

PVector mousePos = new PVector(0, 0);

Camera camera;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  camera = new Camera(width, height, 0.2);
}

void draw(){
  background(255);
  camera.setTranslation(offset);
  camera.setScale(scalar);
  camera.beginDraw();
  PGraphics surface = camera.getRenderSurface();
  surface.background(0);
  surface.fill(255);
  surface.noStroke();
  surface.rect(basePos.x, basePos.y, baseSize, baseSize);
  camera.endDraw();
  camera.drawSurface();
}

void mousePressed(){
  mousePos.set(mouseX, mouseY);
}

void mouseDragged(){
  PVector newPos = new PVector(mouseX, mouseY);
  PVector direction = PVector.sub(newPos, mousePos);
  offset.add(direction);
  mousePos.set(mouseX, mouseY);
}

void mouseWheel(MouseEvent event){
  scalar -= event.getCount() * scaleFactor;
  if(scalar < scaleMin)
    scalar = scaleMin;
  PVector desiredCenter = new PVector(mouseX, mouseY);
  camera.setScaleCenter(desiredCenter);
}

