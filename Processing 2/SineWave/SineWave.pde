int xspacing = 1;   // How far apart should each horizontal location be spaced

float theta = 0.0;  // Start angle at 0
float amplitude = 75.0;  // Height of wave
float frequency = 100.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of frequency and xspacing
float[] yvalues;  // Using an array to store height values for the wave

String waveMode="SINE";

PImage Sine,Saw,Square,Tri;

slider[] sliders=new slider[3];
button[] buttons=new button[4];

void setup() {
  size(840,560);
  frame.setResizable(true);
//  noSmooth();
  rectMode(CENTER);
  textAlign(CENTER);
  imageMode(CENTER);
  
  Sine=loadImage("SineWave.png");
  Saw=loadImage("SawtoothWave.png");
  Square=loadImage("SquareWave.png");
  Tri=loadImage("TriangleWave.png");
  
  buttons[0]=new button(width-220,height-50,"SINE",Sine);
  buttons[1]=new button(width-165,height-50,"SQUARE",Square);
  buttons[2]=new button(width-110,height-50,"TRI",Tri);
  buttons[3]=new button(width-55,height-50,"SAW",Saw);
  
  sliders[0]=new slider(106,height-50,125,15,0,TWO_PI,0.05); //theta incrementation
  sliders[1]=new slider(262,height-50,125,15,0,227,114); //amplitude
  sliders[2]=new slider(418,height-50,125,15,1,720,720); //frequency
}

void draw() {
  background(0);
  calcWave();
  renderWave();
  drawGUI();
}

void calcWave() {
  yvalues = new float[width/xspacing];
  // Increment theta (try different values for 'angular velocity' here
  theta += sliders[0].getValue();
  amplitude=ceil(sliders[1].getValue());
  frequency=ceil(sliders[2].getValue());
  
  dx = (TWO_PI / frequency) * xspacing;

  // For every x value, calculate a y value with sine function
  float x = theta;
  float freq=frequency*2;
  for (int i = 0; i < yvalues.length; i++) {
    if(waveMode=="SINE"){
      yvalues[i]=sin(x)*amplitude; //Sine wave
    }
    else if(waveMode=="SQUARE"){
      yvalues[i] = sgn(sin(x))*amplitude; //Square wave
    }
    else if(waveMode=="TRI"){
      yvalues[i]=2/freq*(x-freq*floor(x/freq+0.5))*pow(-1,floor(x/freq+0.5))*amplitude; //Triangle wave
    }
    else if(waveMode=="SAW"){
      yvalues[i]=2*(x/frequency-floor(0.5+x/frequency))*amplitude; //Reverse sawtooth wave
    }
    
    x+=dx;
  }
}

void renderWave() {
  noFill();
  stroke(0,255,0);
  beginShape();
  for (int x = 1; x < yvalues.length; x++) {
      vertex(x*xspacing, height/2+yvalues[x]-50);
//      point(x*xspacing,height/2+yvalues[x]-50);
      
  }
  endShape();
}

void drawGUI(){
  fill(105);
  noStroke();
  rect(width/2,height-50,width,100);

  for(int i=0;i<sliders.length;i++){
    sliders[i].render();
  }
  
  for(int i=0;i<buttons.length;i++){
    buttons[i].render();
  }
}

void updateSliders(){
  if(waveMode=="SINE"){
    sliders[0].setValues(0,TWO_PI,0.05);
    sliders[1].setValues(0,227,114);
    sliders[2].setValues(1,720,720);
  }
  else if(waveMode=="SQUARE"){
    sliders[0].setValues(0,TWO_PI,0.05);
    sliders[1].setValues(0,227,114);
    sliders[2].setValues(1,720,720);
  }
  else if(waveMode=="TRI"){
    sliders[0].setValues(0,PI*44.7456,0.05); //Ew
    sliders[1].setValues(0,227,114);
    sliders[2].setValues(1,35,20);
  }
  else if(waveMode=="SAW"){
    sliders[0].setValues(0,PI*23.8728,0.5); //Ew
    sliders[1].setValues(0,227,114);
    sliders[2].setValues(1,65,45);
  }
}

int sgn(float val){
  if(val>0){
    return 1;
  }
  else if(val<0){
    return -1;
  }
  return 0;
}

boolean overRect(float posX,float posY,float x, float y, float width, float height)  {
  return posX<x+width/2 && posX>x-width/2 && posY<y+height/2 && posY>y-height/2;
}

void mousePressed(){
  for(int i=0;i<buttons.length;i++){
    buttons[i].update();
  }
}

void mouseDragged(){
  for(int i=0;i<sliders.length;i++){
    sliders[i].update();
  }
}

