int[][] grid;
int w=20;
int h=20;
int tileSize=20;

PVector center;
PVector[] points;
int pNo=1;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  center=new PVector(w/2,h/2);
  points=new PVector[pNo];
  grid = new int[w][h];
  
  for(int i=0;i<pNo;i++){
    points[i]=new PVector(floor(random(w)),floor(random(h)));
  }
  
  stroke(255);
  for(int x=0;x<w;x++){
    for(int y=0;y<h;y++){
      grid[x][y]=0;
    }
  }
  
  newPoints();
  
  grid[int(center.x)][int(center.y)]=125;
  
  background(0);
}

void draw(){
//  background(0);
  fill(0,16);
  rect(0,0,width,height);
  
  for(int x=0;x<w;x++){
    for(int y=0;y<h;y++){
      grid[x][y]=0;
    }
  }
  
  for(PVector p : points){
    if(p.x<w&&p.x>=0&&p.y<h&&p.y>=0){
      grid[int(p.x)][int(p.y)]=255;
    }
  }
  
  grid[int(center.x)][int(center.y)]=125;
  
  for(int x=0;x<w;x++){
    for(int y=0;y<h;y++){
      fill(255,grid[x][y]);
      rect(width/2 - (w/2 * tileSize) + (tileSize * x), height/2 - (h/2 * tileSize) + (tileSize * y), tileSize, tileSize);
    }
  }
}

void newPoints(){
  for(int i=0;i<pNo;i++){
    points[i]=new PVector(floor(random(w)),floor(random(h)));
  }
}

void rotatePoints(float d){
  for(PVector p : points){
    PVector o=p.get();
    p=rotateVector(center,d,p);
    line(width/2 - (w/2 * tileSize) + (tileSize * o.x), height/2 - (h/2 * tileSize) + (tileSize * o.y),width/2 - (w/2 * tileSize) + (tileSize * p.x), height/2 - (h/2 * tileSize) + (tileSize * p.y));
  }
}

PVector rotateVector(PVector pivot, float angle, PVector subject) {
  float s = sin(angle);
  float c = cos(angle);

  subject.x-=pivot.x;
  subject.y-=pivot.y;

  float newX = subject.x*c-subject.y*s;
  float newY = subject.x*s+subject.y*c;

  subject.x=newX+pivot.x;
  subject.y=newY+pivot.y;

  return subject;
}

/*
float x=0;
    float y=0;
    for(PVector p : minos){
      x+=p.x;
      y+=p.y;
    }
    x/=minoNo;
    y/=minoNo;
    PVector c=new PVector(x,y);
*/

void mousePressed(){
  newPoints();
}

void keyPressed(){
  if(key==' '){
    rotatePoints(90);
  }
}


