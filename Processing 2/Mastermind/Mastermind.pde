int numPegs=4;
int score=0;
int[] pegs=new int[numPegs];
ArrayList<int[]> guesses=new ArrayList<int[]>();
ArrayList<int[]> hints=new ArrayList<int[]>();

color red=color(255,0,0);
color yellow=color(255,255,0);
color green=color(0,255,0);
color cyan=color(0,255,255);
color blue=color(0,0,255);
color purple=color(255,0,255);

boolean debug=true;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  noStroke();
  guesses.add(new int[4]);
  hints.add(new int[4]);
  choosePegs();
}

void draw(){
  background(0);
  drawGUI();
  drawGuesses();
  drawHints();
  
  if(debug){
    drawPegs();
  }
}

void drawGUI(){
  fill(84,84,102);
  rect(0,height-102,width,102);
  
  stroke(75);
  strokeWeight(3);
  
  setFill(1);
  ellipse(50,height-51,60,60);
  
  setFill(2);
  ellipse(120,height-51,60,60);
  
  setFill(3);
  ellipse(190,height-51,60,60);
  
  setFill(4);
  ellipse(260,height-51,60,60);
  
  setFill(5);
  ellipse(330,height-51,60,60);
  
  setFill(6);
  ellipse(400,height-51,60,60);
  
  fill(102);
  rect(450,height-75,130,48);
  fill(185);
  textSize(18);
  text("Submit guess",458,height-44);
  
  noStroke();
  
  fill(255);
  textSize(36);
  text("Score: "+score,width-170,height-40);
  
  //Use right-side for text etc.
}
void drawGuesses(){
  int y=height-137;
  for(int i=guesses.size()-1;i>=0;i--){
    setFill(guesses.get(i)[0]);
    ellipse(width/2-60,y,35,35);
    
    setFill(guesses.get(i)[1]);
    ellipse(width/2-20,y,35,35);
    
    setFill(guesses.get(i)[2]);
    ellipse(width/2+20,y,35,35);
    
    setFill(guesses.get(i)[3]);
    ellipse(width/2+60,y,35,35);
    
    y-=45;
  }
}

void drawHints(){
  stroke(75);
  int y=height-137;
  for(int i=hints.size()-1;i>=0;i--){
    setHintFill(hints.get(i)[0]);
    ellipse(width-160,y,35,35);
    
    setHintFill(hints.get(i)[1]);
    ellipse(width-120,y,35,35);
    
    setHintFill(hints.get(i)[2]);
    ellipse(width-80,y,35,35);
    
    setHintFill(hints.get(i)[3]);
    ellipse(width-40,y,35,35);
    
    y-=45;
  }
}

void drawPegs(){
  for(int i=0;i<numPegs;i++){
    setFill(pegs[i]);
    ellipse((i+1)*30,height/2,25,25);
  }
}

void setFill(int index){
  switch(index){
      case 0:
        fill(0);
        break;
      case 1:
        fill(red);
        break;
      case 2:
        fill(yellow);
        break;
      case 3:
        fill(green);
        break;
      case 4:
        fill(cyan);
        break;
      case 5:
        fill(blue);
        break;
      case 6:
        fill(purple);
        break;
  }
}

void setHintFill(int result){
  switch(result){
    case 0:
      fill(0);
      break;
    case 1:
      fill(127.5);
      break;
    case 2:
      fill(255);
  }
}

int calculateHint(int index, int colour){ //0=black - wrong, 1=grey - wrong place, 2=white - correct
  if(pegs[index]==colour){
    return 2;
  }
  
  for(int i=0;i<numPegs;i++){
    if(pegs[i]==colour){
      return 1;
    }
  }
  
  return 0;
}

void calculateHints(int index){
  boolean[] usedIndexes=new boolean[4];
  for(int i=0;i<numPegs;i++){
    if(guesses.get(index)[i]==pegs[i]){
      hints.get(index)[i]=2;
      usedIndexes[i]=true;
    }
  }
  
  for(int i=0;i<numPegs;i++){
    for(int j=0;j<numPegs;j++){
      if(guesses.get(index)[i]==pegs[j] && !(usedIndexes[j])){
        hints.get(index)[i]=1;
        break;
      }
    }
  }
}

void choosePegs(){
  for(int i=0;i<numPegs;i++){
    pegs[i]=int(random(1,7)); //1=red, 2=yellow, 3=green, 4=cyan, 5=blue, 6=pink
  }
  guesses.clear();
  guesses.add(new int[4]);
}

void addGuessPeg(int colour){
  for(int i=0;i<4;i++){
    if(guesses.get(guesses.size()-1)[i]==0){
      guesses.get(guesses.size()-1)[i]=colour;
      break;
    }
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void keyPressed(){
  choosePegs();
}

void mousePressed(){
  for(int i=0;i<6;i++){
    if(overCircle(i*70+50,height-51,60)){
      if(guesses.get(guesses.size()-1)[3]==0){
        addGuessPeg(i+1);
      }
//      else if(java.util.Arrays.equals(guesses.get(guesses.size()-1),pegs)){
//        score++;
//        choosePegs();
//      }
//      else{
//        guesses.add(new int[4]);
//        addGuessPeg(i+1);
//      }
    }
  }
  
  if(overRect(450,height-75,130,48) && guesses.get(guesses.size()-1)[3]!=0){
    if(java.util.Arrays.equals(guesses.get(guesses.size()-1),pegs)){
      score++;
      choosePegs();
    }
    else{
      guesses.add(new int[4]);
      
      hints.add(new int[4]);
      
//      hints.get(hints.size()-2)[0]=calculateHint(0,guesses.get(guesses.size()-2)[0]);
//      hints.get(hints.size()-2)[1]=calculateHint(1,guesses.get(guesses.size()-2)[1]);
//      hints.get(hints.size()-2)[2]=calculateHint(2,guesses.get(guesses.size()-2)[2]);
//      hints.get(hints.size()-2)[3]=calculateHint(3,guesses.get(guesses.size()-2)[3]);
      
      calculateHints(guesses.size()-2);
      println(hints.get(hints.size()-2));
      
      java.util.Arrays.sort(hints.get(hints.size()-2));
    }
  }
}

