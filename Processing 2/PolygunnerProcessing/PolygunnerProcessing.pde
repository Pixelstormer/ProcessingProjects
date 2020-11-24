int[] a;
int f=5;
ArrayList<Bullet> b = new ArrayList<Bullet>();
ArrayList<Bullet> toRemove = new ArrayList<Bullet>();
Player p;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  rectMode(CENTER);
  strokeWeight(3);
  fill(255);
  
  a=new int[4];
  p=new Player(new PVector(width/2,height/2),12);
}

void draw(){
  background(0);
  p.update();
  p.render();
  if(mousePressed){
    p.fire();
  }
  
  for(Bullet B : b){
    B.update();
    B.render();
  }
  b.removeAll(toRemove);
  
  p.renderCursor();
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
    case '1':
      p.switchHammer(0);
      break;
    case '2':
      p.switchHammer(1);
      break;
    case '3':
      p.switchHammer(2);
      break;
    case '4':
      p.switchHammer(3);
      break;
    case '5':
      p.switchHammer(4);
      break;
  }
}

