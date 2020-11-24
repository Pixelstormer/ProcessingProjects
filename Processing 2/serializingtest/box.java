import java.io.*;
import processing.core.*;

class box implements Serializable{
  
  float size;
  String text;
  transient PApplet instance;
  
  private static final long serialVersionUID = 801L;
  
  box(){
    
  }
  
  box(float size, String text, PApplet instance){
    this.size = size;
    this.text = text;
    this.instance = instance;
  }
  
  void render(float x, float y){
    this.instance.fill(255);
    this.instance.rect(x,y,this.size,this.size);
    this.instance.fill(0);
    this.instance.text(this.text,x,y);
  }
  
  String getText(){
    return this.text;
  }
  
  void setText(String text){
    this.text = text;
  }
  
  float getSize(){
    return this.size;
  }
  
  void setSize(float size){
    this.size = size;
  }
}
