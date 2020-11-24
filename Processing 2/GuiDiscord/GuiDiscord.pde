import java.util.List;

GuiCanvas canvas;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  canvas = new GuiCanvas(#23272A);
  canvas.tryAddElement(new RoundButton(width/2 - 32, height/2 - 32, 64, 64, #2C2F33, #000000));
}

void draw(){
  canvas.guiUpdate();
  canvas.render();
}

double sq(double x){
  return x*x;
}

boolean pointIntersectsEllipse(double centerX, double centerY, double xRadius, double yRadius, double x, double y){
  return ( sq(x-centerX) / sq(xRadius) ) + ( sq(y-centerY) / sq(yRadius) ) <= 1;
}

boolean pointIntersectsRectangle(double topLeftX, double topLeftY, double width, double height, double x, double y){
  return x >= topLeftX
      && x <= topLeftX + width
      && y >= topLeftY
      && y <= topLeftY + height;
}

void mousePressed(){
  canvas.onMousePress();
}

void mouseReleased(){
  canvas.onMouseRelease();
}

void mouseMoved(){
  canvas.onMouseMove();
}

void mouseDragged(){
  canvas.onMouseDrag();
}

void mouseWheel(MouseEvent event){
  canvas.onMouseScroll(event);
}

void keyPressed(){
  canvas.onKeyPress();
}

void keyReleased(){
  canvas.onKeyRelease();
}

