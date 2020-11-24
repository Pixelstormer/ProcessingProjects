// Used for overall rotation
float angle;

// Cube count-lower/raise to test performance
int limit = 500;
float time=0;

// Array for all cubes
Cube[] cubes = new Cube[limit];

void setup() {
  size(640, 360, P3D);
  background(0);
  fill(200);
  noStroke();

  // Instantiate cubes, passing in random vals for size and postion
  for (int i = 0; i < cubes.length; i++){
    cubes[i] = new Cube(int(random(-20, 20)), int(random(-20, 20)), 
                        int(random(-20, 20)), int(random(-260, 260)), 
                        int(random(-260, 260)), int(random(-260, 260)));
  }
}

void draw(){
  background(0);

  // Set up some different colored lights
  pointLight(51, 102, 255, 65, 60, 100); 
  pointLight(200, 40, 60, -65, -60, -150);

  // Raise overall light in scene 
  ambientLight(70, 70, 10); 

  // Center geometry in display windwow.
  // you can changlee 3rd argument ('0')
  // to move block group closer(+) / further(-)
  translate(width/2, height/2, -200 + mouseX * 0.65);

  // Rotate around y and x axes
  rotateY(radians(angle));
  rotateX(radians(angle));
  rotateZ(radians(angle));

  // Draw cubes
  for (int i = 0; i < cubes.length; i++){
    cubes[i].update();
    cubes[i].drawCube();
  }
  
  // Used in rotate function calls above
  angle += 0.2;
  time+=2;
}


