import java.util.List;

final float G = 0.66740831;

int amt = 8;

List<CelestialBody> planets;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  planets = new ArrayList<CelestialBody>(amt);
  boolean[][] occupied = new boolean[ceil(width/amt)][ceil(height/amt)];
  for(int i=0; i<amt; i++){
    int x = floor(random(width/amt));
    int y = floor(random(height/amt));
    while(occupied[x][y]){
      x = floor(random(width/amt));
      y = floor(random(height/amt));
    }
    planets.add(new Exoplanet(new PVector(x * amt, y * amt), random(240, 300), random(6, 12)));
    occupied[x][y] = true;
  }
}

void draw(){
  background(0);
  for(CelestialBody e : planets){
    e.applyGravity(planets);
    e.collide(planets);
    e.applyVelocity();
    e.constrainToScreen();
    e.render();
  }
}

