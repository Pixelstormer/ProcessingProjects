ArrayList<minion> minions=new ArrayList<minion>();
ArrayList<PVector> markers=new ArrayList<PVector>();
boolean followMarkers=true;
boolean followMouse=false;
boolean follow=true;
float time=0;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  markers.add(new PVector(width/3,height/2));
  markers.add(new PVector(width/1.5,height/2));
  
  minions.add(new minion(new PVector(random(width),random(height)),random(0.2,1),random(20,45),random(60,255),random(1.1,1.2)));
  minions.add(new minion(new PVector(random(width),random(height)),random(0.2,1),random(20,45),random(60,255),random(1.1,1.2)));
  minions.add(new minion(new PVector(random(width),random(height)),random(0.2,1),random(20,45),random(60,255),random(1.1,1.2)));
  minions.add(new minion(new PVector(random(width),random(height)),random(0.2,1),random(20,45),random(60,255),random(1.1,1.2)));
  minions.add(new minion(new PVector(random(width),random(height)),random(0.2,1),random(20,45),random(60,255),random(1.1,1.2)));
  minions.add(new minion(new PVector(random(width),random(height)),random(0.2,1),random(20,45),random(60,255),random(1.1,1.2)));
  minions.add(new minion(new PVector(random(width),random(height)),random(0.2,1),random(20,45),random(60,255),random(1.1,1.2)));
  minions.add(new minion(new PVector(random(width),random(height)),random(0.2,1),random(20,45),random(60,255),random(1.1,1.2)));
}

void draw(){
  background(0);
  time+=0.06;
  
  for(minion m : minions){
    m.update(minions);
  }
  
  for(PVector p : markers){
    fill(230);
    noStroke();
    triangle(p.x,p.y,p.x-3,p.y-20,p.x+3,p.y-20);
    stroke(222);
    strokeWeight(1);
    ellipse(p.x,p.y-20,12,8);
  }
}

void mousePressed(){
  switch(mouseButton){
    case LEFT:
      followMarkers=false;
      break;
    case RIGHT:
      followMouse=true;
      break;
  }
}

void mouseReleased(){
  switch(mouseButton){
    case LEFT:
      followMarkers=true;
      break;
    case RIGHT:
      followMouse=false;
      break;
  }
}

void keyPressed(){
  switch(key){
    case BACKSPACE:
      try{
        minions.remove(0);
      }
      catch(IndexOutOfBoundsException e){}
      break;
    case ' ':
      minions.add(new minion(new PVector(mouseX,mouseY),random(0.2,1),random(20,45),random(60,255),random(1.1,1.2)));
      break;
    case 'r':
    case 'R':
      follow=!(follow);
      break;
    case 'm':
    case 'M':
      PVector mouse=new PVector(mouseX,mouseY);
      
      int index=0;
      int count=-1;
      float closestDistance;
        
      try{
        closestDistance=PVector.dist(mouse,markers.get(0));
        for(PVector p : markers){
          count++;
          if(PVector.dist(mouse,p)<closestDistance){
            closestDistance=PVector.dist(mouse,p);
            index+=count;
            count=0;
          }
        }
      }
      catch(IndexOutOfBoundsException e){
        closestDistance=16;
      }
      
      if(closestDistance<15){
        markers.remove(index);
      }
      else{
        markers.add(mouse.get());
      }
      break;
  }
}


