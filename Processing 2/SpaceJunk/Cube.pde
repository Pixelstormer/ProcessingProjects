
class Cube {

  // Properties
  float w, h, d;
  float shiftX, shiftY, shiftZ;

  // Constructor
  Cube(float w, float h, float d, float shiftX, float shiftY,float shiftZ){
    this.w = w;
    this.h = h;
    this.d = d;
    this.shiftX = shiftX;
    this.shiftY = shiftY;
    this.shiftZ = shiftZ;
  }

  void update(){
    float x=cos(radians(time))*d;
  }
  
  // Main cube drawing method, which looks 
  // more confusing than it really is. It's 
  // just a bunch of recasingles drawn for 
  // each cube face
  void drawCube(){
    beginShape(QUADS);
    // Front face
    vertex(-sin(radians(time))*w/2 + shiftX, -asin(radians(time))*h/2 + shiftY, -cos(radians(time))*d/2 + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, -asin(radians(time))*h/2 + shiftY, -cos(radians(time))*d/2 + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, asin(radians(time))*h + shiftY, -cos(radians(time))*d/2 + shiftZ); 
    vertex(-sin(radians(time))*w/2 + shiftX, asin(radians(time))*h + shiftY, -cos(radians(time))*d/2 + shiftZ); 

    // Back face
    vertex(-sin(radians(time))*w/2 + shiftX, -asin(radians(time))*h/2 + shiftY, cos(radians(time))*d + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, -asin(radians(time))*h/2 + shiftY, cos(radians(time))*d + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, asin(radians(time))*h + shiftY,cos(radians(time))*d+ shiftZ); 
    vertex(-sin(radians(time))*w/2 + shiftX, asin(radians(time))*h + shiftY,cos(radians(time))*d+ shiftZ);

    // Left face
    vertex(-sin(radians(time))*w/2 + shiftX, -asin(radians(time))*h/2 + shiftY, -cos(radians(time))*d/2 + shiftZ); 
    vertex(-sin(radians(time))*w/2 + shiftX, -asin(radians(time))*h/2 + shiftY,cos(radians(time))*d+ shiftZ); 
    vertex(-sin(radians(time))*w/2 + shiftX, asin(radians(time))*h + shiftY, cos(radians(time))*d + shiftZ); 
    vertex(-sin(radians(time))*w/2 + shiftX, asin(radians(time))*h + shiftY, -cos(radians(time))*d/2 + shiftZ); 

    // Right face
    vertex(sin(radians(time))*w + shiftX, -asin(radians(time))*h/2 + shiftY, -cos(radians(time))*d/2 + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, -asin(radians(time))*h/2 + shiftY, cos(radians(time))*d + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, asin(radians(time))*h + shiftY, cos(radians(time))*d + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, asin(radians(time))*h + shiftY, -cos(radians(time))*d/2 + shiftZ); 

    // Top face
    vertex(-sin(radians(time))*w/2 + shiftX, -asin(radians(time))*h/2 + shiftY, -cos(radians(time))*d/2 + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, -asin(radians(time))*h/2 + shiftY, -cos(radians(time))*d/2 + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, -asin(radians(time))*h/2 + shiftY, cos(radians(time))*d + shiftZ); 
    vertex(-sin(radians(time))*w/2 + shiftX, -asin(radians(time))*h/2 + shiftY, cos(radians(time))*d + shiftZ); 

    // Bottom face
    vertex(-sin(radians(time))*w/2 + shiftX, asin(radians(time))*h + shiftY, -cos(radians(time))*d/2 + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, asin(radians(time))*h + shiftY, -cos(radians(time))*d/2 + shiftZ); 
    vertex(sin(radians(time))*w + shiftX, asin(radians(time))*h + shiftY, cos(radians(time))*d + shiftZ); 
    vertex(-sin(radians(time))*w/2 + shiftX, asin(radians(time))*h + shiftY, cos(radians(time))*d + shiftZ); 

    endShape(); 

    // Add some rotation to each box for pizazz.
    rotateY(radians(1));
    rotateX(radians(1));
    rotateZ(radians(1));
  }
}
