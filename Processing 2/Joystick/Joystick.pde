float s=50;
PVector j;
int[] a;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  rectMode(CENTER);
  strokeWeight(3);
  fill(255);
  
  j=new PVector(0,0);
  a=new int[4];
}

void draw(){
  background(0);
  j.lerp(new PVector((a[3]-a[2])*s,(a[1]-a[0])*s),0.4);
  j.limit(s);
  noStroke();
  translate(width/2,height/2);
  ellipse(j.x,j.y,20,20);
  stroke(255);
  line(0,0,j.x,j.y);
}

void keyPressed(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          a[0]=1;
          break;
        case DOWN:
          a[1]=1;
          break;
        case LEFT:
          a[2]=1;
          break;
        case RIGHT:
          a[3]=1;
          break;
      }
      break;
    case 'w':
    case 'W':
      a[0]=1;
      break;
    case 's':
    case 'S':
      a[1]=1;
      break;
    case 'a':
    case 'A':
      a[2]=1;
      break;
    case 'd':
    case 'D':
      a[3]=1;
      break;
  }
}

void keyReleased(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          a[0]=0;
          break;
        case DOWN:
          a[1]=0;
          break;
        case LEFT:
          a[2]=0;
          break;
        case RIGHT:
          a[3]=0;
          break;
      }
      break;
    case 'w':
    case 'W':
      a[0]=0;
      break;
    case 's':
    case 'S':
      a[1]=0;
      break;
    case 'a':
    case 'A':
      a[2]=0;
      break;
    case 'd':
    case 'D':
      a[3]=0;
      break;
  }
}

