PVector[][][] points;
int w = 5;
int h = 5;
int l = 5;
float dist = 30;

float size = 10;

color from = color(255, 0, 255);
color to = color(255, 255, 0);

PVector center;
PVector centerOffset;

//Rotate by these many degrees around the respective axises each iteration
PVector rotation = new PVector(0.01, 0.01, 1);

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  center = new PVector(width/2, height/2);
  centerOffset = new PVector((float)w/2 * dist, (float)h/2 * dist);
  
  points = new PVector[w][h][l];
  for(int x = 0; x < w; x++){
    for(int y = 0; y < h; y++){
      for(int z = 0; z < l; z++){
        points[x][y][z] = new PVector(x * dist + 1, y * dist + 1, z * dist + 1);
      }
    }
  }
}

void draw(){
  background(0);
  translate(center.x, center.y);
  for(int x = 0; x < w; x++){
    for(int y = 0; y < h; y++){
      for(int z = 0; z < l; z++){
        PVector p = points[x][y][z];
        p.x += sin(radians(frameCount)) * p.z * rotation.x;
        p.y += cos(radians(frameCount)) * p.z * rotation.y;
        stroke(lerpColor(from, to, noise(p.x, p.y, p.z)));
        strokeWeight(size-z);
        point(p.x - centerOffset.x, p.y - centerOffset.y);
      }
    }
  }
}

