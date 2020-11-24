PVector gravity = new PVector(0,0.05);
// The ground is an array of "Ground" objects
int segments = 1000;
Ground[] ground = new Ground[segments];

ArrayList<Orb> orbs = new ArrayList<Orb>();
ArrayList<Orb> toRemove=new ArrayList<Orb>();

Tank player;

void setup(){
  size(640, 360);
  frame.setResizable(true);
  
  // An orb object that will fall and bounce around
  orbs.add(new Orb(50, 50, 3));
  
  rectMode(CENTER);

  // Calculate ground peak heights 
  float[] peakHeights = new float[segments+1];
  for (int i=0; i<peakHeights.length; i++){
    peakHeights[i] = random(height-40, height-30);
  }

  /* Float value required for segment width (segs)
   calculations so the ground spans the entire 
   display window, regardless of segment number. */
  float segs = segments;
  for (int i=0; i<segments; i++){
    ground[i]  = new Ground(width/segs*i, peakHeights[i], width/segs*(i+1), peakHeights[i+1]);
  }
  
  player=new Tank();
  
  background(0);
}


void draw(){
  // Background
  noStroke();
  fill(0, 15);
  rect(width/2,height/2, width, height);
  
  // Draw ground
  fill(127);
//  beginShape();
//  for (int i=0; i<segments; i++){
//    vertex(ground[i].x1, ground[i].y1);
//    vertex(ground[i].x2, ground[i].y2);
//  }
//  vertex(ground[segments-1].x2, height);
//  vertex(ground[0].x1, height);
//  endShape(CLOSE);
  
  beginShape();
  for(int i=0;i<segments;i++){
    vertex(i*(width/segments),ground[i].y1);
    vertex((i+1)*(width/segments),ground[i].y2);
  }
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
  
  player.update();
  player.render();
  
  for(Orb o : orbs){
    o.move();
    o.display();
    o.checkWallCollision();

    // Check against all the ground segments
    for (int i=0; i<segments; i++){
      if(o.checkGroundCollision(ground[i],i)){
        break;
      }
    }
  }
  
  orbs.removeAll(toRemove);
}

void reDrawGround(){
  float segs = segments;
  for (int i=0; i<segments; i++){
    ground[i].reConstruct(width/segs*i, ground[i].y1, width/segs*(i+1), ground[i].y2);
  }
}

void mousePressed(){
  orbs.add(new Orb(mouseX,mouseY,3));
}

