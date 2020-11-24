int layers=12;
int scalar=45;

float sliderY;
float sliderValue;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  rectMode(CENTER);
  colorMode(HSB,255);
  noStroke();
  
  sliderY=height/2;
}

void draw(){
  background(0);
  drawCircle();
  drawColourSlider();
}

void drawCircle(){
  for(float i=layers;i>0;i--){
    fill(sliderValue,map(i,0,layers,0,200),255);
    ellipse(width/2,height/2,i*scalar,i*scalar);
  }
}

void drawColourSlider(){
  sliderY=constrain(sliderY,60,height-60);
  sliderValue=map(sliderY,60,height-60,0,255);
  
  fill(135);
  rect(width-35,height/2,15,height-120,90);
  fill(200);
  ellipse(width-35,sliderY,25,25);
}

void mouseDragged(){
  if(mouseX>width-60&&mouseX<width-10){
    sliderY=mouseY;
  }
}
