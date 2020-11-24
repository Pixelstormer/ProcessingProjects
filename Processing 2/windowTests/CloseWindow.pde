//Close just this window
class CloseWindow extends PApplet{
  
  CloseWindow(){
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  
  void settings(){
    size(840, 560);
  }
  
  void setup(){
    frame.setResizable(true);
  }
  
  void draw(){
    background(0);
    noStroke();
    fill(255);
    ellipse(width/2, height/2, 45, 45);
    fill(0);
    textAlign(CENTER, CENTER);
    text("Close this window", width/2, height/2);
  }
  
  void mousePressed(){
    if(pointIntersectsEllipse(mouseX, mouseY, width/2, height/2, 45, 45)){
      exit();
      println("Closed");
    }
  }
  
  @Override
  void exit()
  {
    dispose();
    closeWindow = null;
  }
}

