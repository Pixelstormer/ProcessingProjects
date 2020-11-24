void setup(){
  size(640,480);
  background(0);
  strokeCap(SQUARE);
}
int x=0;//Circle's X coord
int y=0;//Circle's Y coord
int vel=3;//Circle moves this many pixels/frame
boolean debug=false;
void draw(){
  background(0);
  if (dist(x,y,mouseX,mouseY)>vel){ //Stops spazzing if circle is ontop of cursor
    if (x<mouseX){//Handles movement along X axis
     x+=vel;
    }else{
     x-=vel;
    }
    if (y<=mouseY){//Handles movement along Y axis
      y+=vel;
    }else{
      y-=vel;
    }
  }
  stroke(180);
 
  //Renders the line between circle and cursor
  line(x,y,mouseX,mouseY);
  noStroke();
  
  //Renders the circle
  ellipse(x,y,30,30);
  
  //Renders the circle around the cursor
  fill(0,200,0);
  ellipse(mouseX,mouseY,15,15);
  fill(200);
  
  //Debug info
  text("Cursor coordinates (X,Y): (" +mouseX+","+mouseY+")",4,15);
  text("Circle coordinates (X,Y): ("+x+","+y+")",4,30);
  text("Circle velocity (Pixels/frame): "+vel,4,45);
  text("Cursor velocity (Pixels/frame): "+(round(dist(pmouseX,pmouseY,mouseX,mouseY))),4,60);
  text("Last pressed key: ["+key+"]",4,75);
}

