PVector GlobalOffset;
float globalZoomScale = 1;
float globalZoomStep = 0.1;
float globalZoomCompensator = 1;
Atom atom;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  atom = new Atom(new PVector(width/2,height/2), 6, 12);
  
  GlobalOffset = new PVector(width/2,height/2);
  
  background(0);
  
  imageMode(CENTER);
}

void draw(){
  background(0);
  scale(globalZoomScale);
  translate(GlobalOffset.x, GlobalOffset.y);
  loadPixels();
  
  atom.MoveTo(new PVector(0,0));
  atom.Update();
  atom.Render();
}

void shiftPixels(int shifter){
  for(int i=0;i<pixels.length;i++){
    int mask= ~(0xFF << shifter);
     pixels[i]= pixels[i]&mask;
  }
}

void mouseDragged(){
  GlobalOffset.add(PVector.sub(PVector.mult(new PVector(mouseX,mouseY),globalZoomScale),PVector.mult(new PVector(pmouseX,pmouseY),globalZoomScale)));
}

//void keyPressed(){
//  switch(key){
//    case 'i':
//    case 'I':
//      globalZoomScale+=globalZoomStep;
//      globalZoomCompensator-=globalZoomStep;
////      GlobalOffset.div(globalZoomScale);
//      break;
//    case 'o':
//    case 'O':
//      globalZoomScale-=globalZoomStep;
//      globalZoomCompensator+=globalZoomStep;
////      GlobalOffset.div(globalZoomScale);
//      break;
//  }
//}
