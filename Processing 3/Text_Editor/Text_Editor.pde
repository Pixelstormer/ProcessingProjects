ArrayList<String> Text;

float textPosLineTimer;
float textPosLineInterval;
boolean textPosLineShowing;
PVector textPosLine;
int targetLineX;

float textHeight;
float spaceBetweenChars;
float spaceBetweenLines;

PVector positiveIndent;
PVector negativeIndent;

void setup(){
  size(840,460);
  surface.setResizable(true);
  
  Text = new ArrayList<String>();
  Text.add("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  Text.add("123456789");
  Text.add("abcdefg");
  Text.add(" ");
  Text.add("A B C D E F G");
  
  textPosLineTimer = millis();
  textPosLineInterval = 800;
  textPosLineShowing = false;
  textPosLine = new PVector(0,0);
  targetLineX = 0;
  
  textHeight = 45;
  spaceBetweenChars = 0;
  spaceBetweenLines = 0;
  
  positiveIndent = new PVector(15,15);
  negativeIndent = new PVector(15,15);
  
  textAlign(LEFT,TOP);
  
  background(0);
}

void draw(){
  background(0);
  
  if(millis()-textPosLineTimer > textPosLineInterval){
    resetTextPosLineTimer();
  }
  
  float x=positiveIndent.x;
  float y=positiveIndent.y;
  
  float lineX = -1;
  float lineY = y;
  for(String s : Text){
    for(int i=0;i<s.length();i++){
      char c = s.charAt(i);
      
      if(s.equals(Text.get(int(textPosLine.y)))){
        lineY = y;
        if(i == textPosLine.x){
          lineX = x;
        }
      }
      
      text(c,x,y);
      x+=spaceBetweenChars+textWidth(c);
      if((width-negativeIndent.x)-x<=0){
        x=positiveIndent.x;
        y+=spaceBetweenLines+textAscent()+textDescent();
      }
    }
    if(lineX==-1){
      lineX=x;
    }
    y+=spaceBetweenLines+textAscent()+textDescent();
    x=positiveIndent.x;
  }
  
  if(textPosLineShowing){
    stroke(255);
    line(lineX,lineY,lineX,lineY+textAscent()+textDescent());
  }
}

String insert(String original, String toInsert, int position){
  String p1 = original.substring(0,position);
  String p2 = original.substring(position);
  return p1 + toInsert + p2;
}

void resetTextPosLineTimer(){
  textPosLineShowing = !textPosLineShowing;
  textPosLineTimer = millis();
}

void resetTextPosLineTimer(boolean state){
  textPosLineShowing = state;
  textPosLineTimer = millis();
}

void keyPressed(){
  switch(key){
    case CODED:
      switch(keyCode){
        case LEFT:
          textPosLine.x--;
          break;
        case RIGHT:
          textPosLine.x++;
          break;
        case UP:
          textPosLine.y--;
          break;
        case DOWN:
          textPosLine.y++;
          break;
      }
      int X = int(textPosLine.x);
      int Y = int(textPosLine.y);
      textPosLine.y = constrain(textPosLine.y,0,Text.size()-1);
      textPosLine.x = constrain(textPosLine.x,0,Text.get(int(textPosLine.y)).length());
      if(X != textPosLine.x || Y != textPosLine.y){
        resetTextPosLineTimer();
      }
      else{
        resetTextPosLineTimer(true);
      }
      break;
    case BACKSPACE:
      if(textPosLine.x>0){
        Text.set(int(textPosLine.y),Text.get(int(textPosLine.y)).substring(0,int(textPosLine.x-1))+Text.get(int(textPosLine.y)).substring(int(textPosLine.x)));
        textPosLine.x--;
        resetTextPosLineTimer(true);
      }
      else{
        resetTextPosLineTimer();
      }
      break;
    case TAB:
      
      break;
    case ENTER:
    case RETURN:
      Text.add(int(textPosLine.y),Text.get(int(textPosLine.y)).substring(0,int(textPosLine.x)));
      textPosLine.y++;
      Text.set(int(textPosLine.y),Text.get(int(textPosLine.y)).substring(int(textPosLine.x)));
      textPosLine.x = 0;
      resetTextPosLineTimer(true);
      break;
    case ESC:
      exit();
      break;
    case DELETE:
      if(textPosLine.x<Text.get(int(textPosLine.y)).length()){
        Text.set(int(textPosLine.y),Text.get(int(textPosLine.y)).substring(0,int(textPosLine.x))+Text.get(int(textPosLine.y)).substring(int(textPosLine.x+1)));
        resetTextPosLineTimer(true);
      }
      else{
        resetTextPosLineTimer();
      }
      break;
    default:
      Text.set(int(textPosLine.y),insert(Text.get(int(textPosLine.y)),str(key),int(textPosLine.x)));
      textPosLine.x++;
      resetTextPosLineTimer();
      break;
  }
}