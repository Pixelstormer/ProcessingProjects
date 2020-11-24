import javax.swing.JColorChooser;
import java.awt.Color;
Color javaColor;

void draw(){
  noStroke();
  color c = color(255,255,255);
  if(javaColor!=null) 
        c       = color(javaColor.getRed(),javaColor.getGreen(),javaColor.getBlue());
  fill(c);
  ellipse(width/2,height/2,width/2,height/2);
}

void mousePressed(){
  javaColor  = JColorChooser.showDialog(this,"Java Color Chooser",Color.white);
}
