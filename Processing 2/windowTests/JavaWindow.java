import processing.core.PApplet;

public class JavaWindow extends PApplet{
  JavaWindow(){
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  
  public void settings(){
    size(840, 560);
  }
  
  public void setup(){
    frame.setResizable(true);
  }
  
  public void draw(){
    background(0);
    noStroke();
    fill(255);
    ellipse(width/2, height/2, 45, 45);
    fill(0);
    textAlign(CENTER, CENTER);
    text("Exit whole app", width/2, height/2);
  }
  
  public void mousePressed(){
    if(pointIntersectsEllipse(mouseX, mouseY, width/2, height/2, 45, 45)){
      dispose();
    }
  }
  
  private boolean pointIntersectsEllipse(float pointX, float pointY, float circleX, float circleY, float circleXRadius, float circleYRadius){
    return ( sq(pointX-circleX) / sq(circleXRadius) ) + ( sq(pointY-circleY) / sq(circleYRadius) ) <= 1;
  }
}

