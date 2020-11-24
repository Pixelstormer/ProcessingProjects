ArrayList<Rocket> shooter;
ArrayList<Rocket> toRemove=new ArrayList<Rocket>();

void setup(){
  size(640,480);
  shooter=new ArrayList<Rocket>();
  frame.setResizable(true);
}

void draw(){
//  background(0);
  fill(0,102);
  rect(0,0,width,height);
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
  stroke(255);
  point(width/2,height/2);
  noStroke();
}

void mousePressed(){
  shooter.add(new Rocket(10,0.4,45,1.02,240,40,540,//Rocket stuff
                         48,-10,1,false,false,true,false,9,6,3));//Atom stuff
}

void keyPressed(){
  shooter.add(new Rocket(10,0.4,45,1.02,240,40,540,//Rocket stuff
                         48,-10,1,false,false,true,false,9,6,3));//Atom stuff
}
