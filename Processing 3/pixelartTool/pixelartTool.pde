int imageWidth = 32;
int imageHeight = 32;
float imageXOrigin;
float imageYOrigin;
float scaleFactor = 10;
PGraphics image;

void setup(){
  size(840,560);
  surface.setResizable(true);
  imageMode(CENTER);
  noSmooth();
  
  image = createGraphics(imageWidth, imageHeight);
  
  image.beginDraw();
  image.loadPixels();
  for(int i=0; i<image.pixels.length; i++){
    image.pixels[i] = color(random(255));
  }
  image.updatePixels();
  image.endDraw();
}

void draw(){
  background(0);
  
  updateVariables();
  
  doImageModification();
  
  renderImage();
}

void updateVariables(){
  imageXOrigin = width/2 - imageWidth * scaleFactor/2;
  imageYOrigin = height/2 - imageHeight * scaleFactor/2;
}

void renderImage(){
  translate(width/2,height/2);
  scale(scaleFactor);
  image(image, 0,0,imageWidth, imageHeight);
}

void doImageModification(){
  if(mousePressed){
    int scaledMouseX = scaleToImageCoordinates(mouseX, true);
    int scaledMouseY = scaleToImageCoordinates(mouseY, false);
    int oldMouseX = scaleToImageCoordinates(pmouseX, true);
    int oldMouseY = scaleToImageCoordinates(pmouseY, false);
    if(scaledMouseX < 0 || scaledMouseX >= imageWidth || scaledMouseY < 0 || scaledMouseY >= imageHeight ||
       false)//oldMouseX < 0    || oldMouseX >= imageWidth    || oldMouseY < 0    || oldMouseY >= imageHeight)
      return;
    
    oldMouseX = constrain(oldMouseX,0,imageWidth);
    oldMouseY = constrain(oldMouseY,0,imageHeight);
    
    image.beginDraw();
    image.stroke(255,0,0);
    image.line(oldMouseX,oldMouseY,scaledMouseX,scaledMouseY);
    image.endDraw();
  }
}

int scaleToImageCoordinates(float value, boolean isXAxis){
  return int((value - ((isXAxis)?imageXOrigin:imageYOrigin))/scaleFactor);
}