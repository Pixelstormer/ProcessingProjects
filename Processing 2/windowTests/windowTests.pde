CloseWindow closeWindow;
ExitWindow exitWindow;
HideWindow hideWindow;
JavaWindow javaWindow;

final float radius = 65;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
}

void draw(){
  background(0);
  fill(255, 0, 0);
  noStroke();
  ellipse(width/3, height/2, radius, radius);
  fill(0, 255, 0);
  ellipse(width/2, height/2, radius, radius);
  fill(0, 0, 255);
  ellipse(width/1.5, height/2, radius, radius);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Close Window", width/3, height/2);
  text("Exit Window", width/2, height/2);
  text("Hide Window", width/1.5, height/2);
}

void mousePressed(){
  //Close Window
  if(pointIntersectsEllipse(mouseX, mouseY, width/3, height/2, radius/2, radius/2)){
    if(closeWindow == null)
      closeWindow = new CloseWindow();
  }
  
  //Exit Window
  if(pointIntersectsEllipse(mouseX, mouseY, width/2, height/2, radius/2, radius/2)){
    exitWindow = new ExitWindow();
    javaWindow = new JavaWindow();
  }
  
  //Hide Window
  if(pointIntersectsEllipse(mouseX, mouseY, width/1.5, height/2, radius/2, radius/2)){
    hideWindow = new HideWindow();
  }
}

public boolean pointIntersectsEllipse(float pointX, float pointY, float circleX, float circleY, float circleXRadius, float circleYRadius){
  return ( sq(pointX-circleX) / sq(circleXRadius) ) + ( sq(pointY-circleY) / sq(circleYRadius) ) <= 1;
}

