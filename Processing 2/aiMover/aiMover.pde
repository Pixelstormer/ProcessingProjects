import java.util.concurrent.ThreadLocalRandom;

Game game;

Mover m;
Objective o;
Goal g;

final float OBJECTIVE_ROTATION_INDEX = 0.015;
final int ID_LENGTH = 8;
final String ALPHANUMERICS = "abcdefghijklmnopqrstuvwxyz"+
                             "ABCDEFGHIJKLMNOPQRSTUVWXYZ"+
                             "0123456789";

void setup(){
  size(840,560);
  frame.setResizable(true);
  noStroke();
  text("LOADING", width/2,height/2);
  
  m = new Mover(new PVector(width/2,height/2),10,6,5,6,20);
  o = new Objective(new PVector(width/4,height/2), 8);
  Objective o2 = new Objective(new PVector(width/2,height/4), 10);
  g = new Goal(new PVector(width/1.5,height/2),20);
  
  ArrayList<GameObject> GOs = new ArrayList<GameObject>(4);
  GOs.add(m);
  GOs.add(o);
  GOs.add(g);
  GOs.add(o2);
  
  game = new Game(GOs);
  
  //game.addGameObject(new Objective(new PVector(width/2,height/4), 10));
}

void draw(){
  game.iterate();
}

float directionBetween(PVector from, PVector to, PVector heading){
  return (to.x-from.x)
        *((from.y+heading.y)-from.y)
        -(to.y-from.y)
        *((from.x+heading.x)-from.x);
}

void mousePressed(){
  m.updateTarget(new PVector(mouseX,mouseY));
}

