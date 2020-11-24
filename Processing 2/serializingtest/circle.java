import java.io.*;
import processing.core.*;

class circle extends box implements Serializable{
  private static final long serialVersionUID = 317L;
  circle(){}
  circle(float size, String text, PApplet instance){
    super(size,text,instance);
  }
  void render(float x, float y){
    this.instance.fill(0);
    this.instance.stroke(255);
    this.instance.ellipse(x,y,this.size,this.size);
    this.instance.fill(255);
    this.instance.text(this.text,x,y);
  }
}
