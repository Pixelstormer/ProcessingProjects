ArrayList<PVector> points;

float distanceBetweenPoints = 1;
float viscocityPercent = 0.05;
float pull = 12;
int pullRadius = 64;

final float realViscocity = viscocityPercent/100;
final float workingViscocity = realViscocity/2;

int viscocityRadius = 100;

float timer;
float timerInterval;

void setup() {
  size(840, 560);
  frame.setResizable(true);

  timerInterval=0.1;
  timer=0;

  points = constructPointList(0, width+distanceBetweenPoints, distanceBetweenPoints, height/2);

  background(0);
}

void draw() {
  background(0);
  timer+=timerInterval;
  
  points = resizePointList(points, distanceBetweenPoints, 0, width+distanceBetweenPoints, height/2);
  
  updateWave();
  drawWave();
  pullWave();
}

void pullWave(){
  if(mousePressed){
    float closest = Float.POSITIVE_INFINITY;
    int index = -1;
    for(int i=0;i<points.size();i++){
      if(abs(points.get(i).x-mouseX)<=closest){
        index = i;
        closest = abs(points.get(i).x-mouseX);
      }
    }
//    points.get(index).y+=(mouseY-points.get(index).y)*pull;
    
    for(int i=index-pullRadius/2;i<=index+pullRadius/2;i++){
      if(i>0&&i<points.size()-1){
        points.get(i).y+=(mouseY-points.get(i).y)*(pull/100);
        stroke(255);
        line(mouseX,mouseY,points.get(i).x,points.get(i).y);
      }
    }
  }
}

void updateWave(){
  applyWaveUpdate(createUpdatedWave());
}

ArrayList<PVector> createUpdatedWave(){
  ArrayList<PVector> update = points;
  
  float targetHeight = height/2;
  for(int i=0;i<points.size();i++){
    PVector p = points.get(i);
    
    float pd = 0;
    
    for(int j=i;j>=i-viscocityRadius/2;j--){
      if(j>0&&j<points.size()-1){
        float l = points.get(j).y;
        pd+=(l-p.y)*map(j,i-viscocityRadius/2,i,0,1)*workingViscocity;
      }
    }
    
    for(int j=i;j<=i+viscocityRadius/2;j++){
      if(j>0&&j<points.size()-1){
        float r = points.get(j).y;
        pd+=(r-p.y)*map(j,i,i+viscocityRadius/2,1,0)*workingViscocity;
      }
    }
    
    pd+=(targetHeight-p.y)*workingViscocity;
    
    update.get(i).y+=pd;
  }
  return update;
}

void applyWaveUpdate(ArrayList<PVector> update){
  points = update;
}

void drawWave() {
  noStroke();
  fill(100, 100, 220);
  beginShape();
  vertex(0, height);
  for(int i=0;i<points.size();i++){
    vertex(points.get(i).x,points.get(i).y);
  }
  vertex(width, height);
  endShape();
}

ArrayList<PVector> constructPointList(float l, float r, float d, float y) {
  ArrayList<PVector> p = new ArrayList<PVector>();
  for (float i=l-d; i<=r+d; i+=d) {
    p.add(new PVector(i, y));
  }
  return p;
}

ArrayList<PVector> resizePointList(ArrayList<PVector> o, float d, float l, float r, float y) {
  float s = o.size()*d;
  float w = r-l;
  if (w>s) {
    o = extendPointList(o, d, r, y);
  } else if (s>w+d) {
    o = trimPointList(o, d, l, r);
  }
  return o;
}

ArrayList<PVector> extendPointList(ArrayList<PVector> o, float d, float r, float y) {
  float s = o.size()*d;
  for (float i=s; i<=r+d; i+=d) {
    o.add(new PVector(i, y));
  }
  return o;
}

ArrayList<PVector> trimPointList(ArrayList<PVector> o, float d, float l, float r) {
  float w = r-l;
  for (float i=o.size ()-1; i>floor(w/d)+1; i--) {
    o.remove(floor(i));
  }
  return o;
}

