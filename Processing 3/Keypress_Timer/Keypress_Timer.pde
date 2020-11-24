import java.util.Map;

HashMap<Character, Integer> heldKeys;

void setup(){
  size(840,560);
  surface.setResizable(true);
  
  heldKeys = new HashMap<Character,Integer>();
  
  background(0);
}

void draw(){
  for(Map.Entry e : heldKeys.entrySet()){
    heldKeys.put((char)e.getKey(),(int)e.getValue()+1);
  }
}

void keyPressed(){
  if(!heldKeys.containsKey(key)){
    heldKeys.put(key,0);
  }
}

void keyReleased(){
  println("Pressed key ["+key+"] for ["+heldKeys.get(key)+"] frames.");
  heldKeys.remove(key);
}