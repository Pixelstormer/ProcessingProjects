int milliseconds = 0;
int seconds = 0;
int minutes = 0;
int hours = 0;

int milInSec = 1000;
int secInMin = 60;
int minInHour = 60;

void setup(){
  size(840,560);
  frame.setResizable(true);
  textAlign(CENTER,CENTER);
}

void draw(){
  background(0);
  milliseconds = millis();
  seconds = floor(milliseconds/milInSec);
  minutes = floor(seconds/secInMin);
  seconds %= secInMin;
  hours = floor(minutes/minInHour);
  minutes %= minInHour;
  
  String text;
  if(hours<10){
    text = "0"+str(hours);
  }
  else{
    text = str(hours);
  }
  text+=" : ";
  if(minutes<10){
    text += "0"+str(minutes);
  }
  else{
    text += str(minutes);
  }
  text+=" : ";
  if(seconds<10){
    text+="0"+str(seconds);
  }
  else{
    text+=str(seconds);
  }
  
  fill(255);
  noStroke();
  textSize(32);
  text(text,width/2,height/2);
}

