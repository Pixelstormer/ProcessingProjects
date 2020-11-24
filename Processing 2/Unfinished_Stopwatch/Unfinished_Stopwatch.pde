boolean state=true; //False=stopped, true=running
String millis;
int[] splitMillis;

void setup(){
  size(640,480);
  
  noStroke();
  fill(255);
  textSize(40);
  textAlign(CENTER);
}

void draw(){
  background(0);
  
  if(state){
    
    millis=nfc(millis());
    splitMillis=int(split(millis,','));
  }
  
  try{
    text(splitMillis[splitMillis.length-3]+":"+splitMillis[splitMillis.length-2]+":"+splitMillis[splitMillis.length-1],width/2,height/2);
  }
  catch(ArrayIndexOutOfBoundsException e){
    text("00:"+splitMillis[splitMillis.length-2]+":"+splitMillis[splitMillis.length-1],width/2,height/2);
  }
}

void keyPressed(){
  switch(key){
    case ' ':
      state=!(state);
      break;
  }
}
