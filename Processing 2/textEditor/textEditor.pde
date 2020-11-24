String string="";
boolean cursor=false;
int timer=0;
int interval=45;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  text("Loading...",width/2,height/2);
  
  stroke(255);
}

void draw(){
  background(0);
  timer++;
  
  textAlign(TOP,LEFT);
  
  if(timer>=interval){
    timer=0;
    cursor=!(cursor);
  }
    
  text(string,0,0,width,height);
}

void keyPressed(){
  cursor=!(cursor);
  if((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z') || (key>='0' && key<='9')) {
    string+=key;
  }
  else if(key==ENTER || key==RETURN){
    string+="\n";
  }
  else if(key==BACKSPACE && string.length()>0){
    string=string.substring(0,string.length()-1);
  }
}

