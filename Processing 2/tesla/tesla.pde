float teslaX=random(610);
float teslaY=random(450);
int noiseLevel=1000;
void setup(){
  size(640,480);
  background(0);
  noFill();
  rectMode(CENTER);
}
void draw(){
  background(0);
  float strokeRed=random(0,64);
  float strokeGreen=random(0,191);
  float noiseX=random(-noiseLevel,noiseLevel);
  float noiseY=random(-noiseLevel,noiseLevel);
  float noiseX2=random(-noiseLevel,noiseLevel);
  float noiseY2=random(-noiseLevel,noiseLevel);
  stroke(255);
  ellipse(teslaX,teslaY,15,15);
  stroke(strokeRed,strokeGreen,255);
  curve(noiseX,noiseY,mouseX,mouseY,teslaX,teslaY,noiseX2,noiseY2);
  
  text("Cursor coordinates (X,Y): (" +mouseX+","+mouseY+")",4,15);
  text("Cursor velocity (Pixels/frame): "+(round(dist(pmouseX,pmouseY,mouseX,mouseY))),4,30);
  text("Tesla coordinates: X:"+teslaX+", Y: "+teslaY,4,45);
  text("Noise levels: X1: "+noiseX,4,60);
  text(" Y1: "+noiseY,72,75);
  text(" X2: "+noiseX2,72,90);
  text(" Y2: "+noiseY2,72,105);
  text(" Maximum bounds: ± "+noiseLevel,72,120);
}
