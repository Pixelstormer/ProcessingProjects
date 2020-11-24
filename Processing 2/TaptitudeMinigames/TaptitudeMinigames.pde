import java.io.File;

int i = 0;

ArrayList<Minigame> ActiveGames;
String[] ForbiddenSpriteNames = {
  "TaptitudeSquare",
  "TaptitudeRounded"
};

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  ActiveGames = new ArrayList<Minigame>();
//  String[] dataFolder = (new File(sketchPath+"/data")).list();
//  for(String s : dataFolder){
//    String[] parsed = split(s,".");
//    String fileName = "";
//    for(int i=0;i<parsed.length-1;i++){
//      fileName+=parsed[i];
//    }
//    String fileExtension = parsed[parsed.length-1];
//    if(fileExtension.equals("png")){
//      LoadedSprites.put(fileName,loadImage(s));
//    }
//  }
}

void draw(){
  background(0);
  
  for(Minigame m : ActiveGames){
//    PApplet.runSketch(args,m);
  }
}

void addNewGame(){
  ActiveGames.add(new ShapeNinja(650,540,450,4,1500));
  ActiveGames.add(new PictureMatch(650,540,loadImage("TaptitudeRounded.png"),new PVector(50,75),new PVector(4,4),new PVector(12,12),sketchPath+"/data/CardSprites",ForbiddenSpriteNames));
}

void mousePressed(){
  addNewGame();
}

void keyPressed(){
  println(i);
}


