//Attempt at making a GUI with buttons and menus
//without using the G4P lib

Button button;

void setup(){
  size(640,480);
  button=new Button(width/2,height/2,"CIRCLE",45,45);
}

void draw(){
  background(0);
  button.check();
  button.render();
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

