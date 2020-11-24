String[] lines;
int score;

void setup(){
  size(640,480);
  lines = loadStrings("scores.txt");
}

void draw(){
  background(0);
  text(lines[0],4,15);
  text(score,4,height-15);
}

void mousePressed(){
  score++;
}

void keyPressed(){
  String[] newScore=new String[1];
  newScore[0]=str(score);
  if(score>int(lines[0])){
    saveStrings("scores.txt",newScore);
  }
  exit();
}

