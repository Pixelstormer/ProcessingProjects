ArrayList<Rocket> shooter;
ArrayList<Rocket> toRemove=new ArrayList<Rocket>();

PImage img;

void setup(){
  size(640,480);
  shooter=new ArrayList<Rocket>();
  frame.setResizable(true);
  imageMode(CENTER);
  img=loadImage("rocket.gif");
}

void draw(){
  background(0);
  for(Rocket r : shooter){
    if(r.primed()>r.explodetime){
      r.update();
      r.display();
    }else{
      r.detonate();
    }
    if(r.lifetime>r.maxLifeTime){
      r.primed=true;
    }
    if(r.primed()<=0){
      toRemove.add(r);
    }
  }
  shooter.removeAll(toRemove);
}

void mousePressed(){
  shooter.add(new Rocket(10,0.4,45,1.02,240,40,540));
}

void keyPressed(){
  shooter.add(new Rocket(10,0.4,45,1.02,240,40,540));
}
