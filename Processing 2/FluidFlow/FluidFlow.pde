FluidSystem system;
float fillAmt = 100;
float scrollSpeed = 0.5;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  system = new FluidSystem(250, 250, 100, 25, 50, 50, 1);
  system.addFluid(2, 2, 100);
}

void draw(){
  background(0);
  system.applyIteration(system.getNextIteration());
  system.render(color(255), color(0, 0, 255));
  fill(255);
  text(int(frameRate), 4, 15);
}

void square(float x, float y, float size){
  rect(x, y, size, size);
}

void square(PVector location, float size){
  rect(location.x, location.y, size, size);
}

void rect(PVector location, float width, float height){
  rect(location.x, location.y, width, height);
}

void mousePressed(){
  FluidSystem.SystemCamera camera = system.getCamera();
  float scalar = camera.getScalar();
  PVector offset = camera.getOrigin();
  int systemX = camera.scaleXtoIndex(mouseX);
  int systemY = camera.scaleYtoIndex(mouseY);
  if(systemX >= 0
  && systemX < system.getWidth()
  && systemY >= 0
  && systemY < system.getHeight()){
    FluidSystem.FluidCell targetCell = system.getCell(systemX, systemY);
    targetCell.generateFluid(fillAmt);
  }
}

void mouseWheel(MouseEvent event){
  FluidSystem.SystemCamera camera = system.getCamera();
  float scaledBy = event.getCount() * -scrollSpeed;
  PVector scaleOffset = new PVector(mouseX - mouseX*scaledBy,
                                    mouseY - mouseY*scaledBy);
  scaleOffset.sub(camera.getOrigin());
  camera.offsetScalar(scaledBy);
  camera.offsetOrigin(scaleOffset);
}

