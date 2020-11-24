//Interface for objects with collision

interface CollidableObject{
  //For more complex polygons
  ArrayList<PVector> Vertices = new ArrayList<PVector>();
  PVector pollForBoundsCollision(PVector center, PVector bounds);
}