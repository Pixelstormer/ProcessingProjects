Button[] buttons;
color background;

void setup() {
  size(640, 480);
  frame.setResizable(true);
  background(0);
  rectMode(CENTER);
  textAlign(CENTER);

  buttons=new Button[4];
  buttons[0]=new Button(0, width/2, height/2, 45, 45, true, "Orange");
  buttons[1]=new Button(1, width/1.5, height/2, 45, 45, false, "Green_square");
  buttons[2]=new Button(2, width/3, height/2, 45, 45, false, "Bl ue");
  buttons[3]=new Button(1, width/2, height/1.5, 60, 60, true, "Green circle");
}

void draw() {
  for (Button b : buttons) {
    b.render();
    if (b.checkOver()) {
      fill(255);
      buttonScrolled(b);
    }
  }
}

boolean overRect(float x, float y, int width, int height) {
  if (mouseX >= x-width/2 && mouseX <= x+width/2 && 
    mouseY >= y-height/2 && mouseY <= y+height/2) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(float x, float y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

void colourScheme(int scheme) {
  switch(scheme) {
  case 0:
    fill(#F77A19);
    stroke(#7B7A7C);
    strokeWeight(3);
    break;
  case 1:
    fill(#06BF4E);
    stroke(#EA80F0);
    strokeWeight(2);
    break;
  case 2:
    fill(#1521E8);
    stroke(#5E0F93);
    strokeWeight(8);
    break;
  }
}

void buttonPressed(Button b) {
  colourScheme(b.scheme);
  rect(width/2, height/2, width, height);
  for (Button u : buttons) {
    u.render();
  }
}

void buttonScrolled(Button b) {
  textSize(16);
  text(b.name, b.x, b.y);
}

void mouseReleased() {
  for (Button b : buttons) {
    if (b.checkOver()) {
      b.clicked();
    }
  }
}

