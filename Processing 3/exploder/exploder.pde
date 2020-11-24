ArrayList<Rocket> shooter;
ArrayList<Rocket> toRemove=new ArrayList<Rocket>();

void setup(){
  size(640,480);
  shooter=new ArrayList<Rocket>();
  frame.setResizable(true);
}

void draw(){
  background(0);
  for(Rocket r : shooter){
    r.update();
    r.display();
    if(r.primed()<=0){
      toRemove.add(r);
      r.detonate();
    }
  }
  shooter.removeAll(toRemove);
}

void mousePressed(){
  shooter.add(new Rocket(10,0.4,45,1.02,120));
}
