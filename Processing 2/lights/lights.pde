int lightx;
int lighty;

int secondx;
int secondy;

int x3;
int y3;

color light=color(102,230,66);
color second=color(13,42,220);
color red=color(216,12,85);
color black=color(0);

void setup(){
  size(840,560);
  frame.setResizable(true);
  background(0);
  
  lightx=floor(width/1.5);
  lighty=height/2;
  secondx=floor(width/3);
  secondy=height/2;
  x3=width/2;
  y3=height/2;
  noStroke();
}

void draw(){
  loadPixels();
  for(int x=0;x<width;x++){
    for(int y=0;y<height;y++){
      color lightColour=lerpColor(light,black,map(dist(x,y,lightx,lighty),0,130,0,1));
      color secondColour=lerpColor(second,black,map(dist(x,y,secondx,secondy),0,185,0,1));
      color redC=lerpColor(red,black,map(dist(x,y,x3,y3),0,120,0,1));
      
      color average1=calculateAverage(lightColour,redC);
      color average2=calculateAverage(lightColour,redC);
      color average3=calculateAverage(secondColour,redC);
      
      pixels[y*width+x]=calculateAverage(average1,secondColour);
    }
  }
  updatePixels();
  
  fill(255);
  text(frameRate,4,15);
}

color calculateAverage(color one,color two){
  return lerpColor(one,two,0.5);
}

void keyPressed(){
  switch(key){
    case 'a':
    case 'A':
      lightx=mouseX;
      lighty=mouseY;
      break;
    case 's':
    case 'S':
      secondx=mouseX;
      secondy=mouseY;
      break;
    case 'd':
    case 'D':
      x3=mouseX;
      y3=mouseY;
      break;
  }
}

