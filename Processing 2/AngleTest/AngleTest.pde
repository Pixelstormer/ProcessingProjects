int amt = 3;
float dist = 50;
float start = 45;
boolean extra = true;

void setup(){
  size(200,200);
  stroke(255);
  strokeWeight(2);
}

void draw(){
  background(0);
  if(amt>0){
    start = map(mouseX,0,width,0,360);
    translate(width/2,height/2);
    PVector origin = PVector.fromAngle(radians(start));
    origin.setMag(dist);
    PVector offset = origin.get();
    line(0,0,origin.x,origin.y);
    float angle = 360/(amt+((extra)?1:0));
    if(extra){
      offset.rotate(radians(180+angle));
    }
    for(int i=0;i<amt;i++){
      ellipse(offset.x,offset.y,15,15);
      offset.rotate(radians(angle));
    }
  }
}

void mousePressed(){
  switch(mouseButton){
    case LEFT:
      amt++;
      break;
    case RIGHT:
      if(amt>0){
        amt--;
      }
      break;
  }
}
