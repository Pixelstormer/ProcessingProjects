import java.util.List;

List<Magnet> magnets;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  magnets = new ArrayList<Magnet>();
}

void draw(){
  background(0);
  
  for(Magnet m : magnets){
    m.render();
  }
}

