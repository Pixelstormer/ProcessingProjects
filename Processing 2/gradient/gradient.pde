float time=0;
float increment=0.0075;

boolean started=false;

boolean recording=false;

void setup(){
  size(640,580);
  noiseSeed(8);
  noiseDetail(2);
  frame.setResizable(true);
}

void draw(){
  if(started){
    colorMode(HSB);
    loadPixels();
    float xoff=0.0;
    
    for (int i = 0; i < width; i++) {
      xoff+=increment;
      float yoff=0.0;
      
      for (int j = 0; j < height; j++) {
        yoff+=increment;
        float bright=0;
        float val=noise(xoff,yoff,time)*255;
//        val=random(255);
  
        for(int k=0;max(val,k)!=k;k+=8){
          bright=k;
        }
        
        float h=map(bright,0,255,bright/2,bright*1.4);
        float s=bright*2;
        float b=map(bright,0,255,0,510);
  
        pixels[i+j*width] = color(h,s,b);
      }
    }
    updatePixels();
    if(recording){
      saveFrame("gradient/frame####.png");
    }
    time+=0.008;
  }else{
    background(0);
    textAlign(CENTER,CENTER);
    colorMode(RGB);
    fill(255);
    text("GRADIENT\n\nPress any key to begin.\nPress ESC to exit.",width/2-70,height/2-70,140,140);
    fill(255,0,0);
    text("WARNING: May be slower on weaker computers, and may slow down if window is made larger.\nAlso, all resizable Processing programs will crash if you resize it so height is 0.",width/2-190,height-height/6-10,380,140);
  }
}

void keyPressed(){
  started=true;
  if(key==' '){
    if(recording){
      println("Stopped recording.");
    }else{
      println("Started recording.");
    }
    recording=!(recording);
  }
}


