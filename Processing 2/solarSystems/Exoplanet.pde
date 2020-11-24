class Exoplanet extends CelestialBody{
  //Big enough to be spherical but too small to warrant unique name + rendering
  
  Exoplanet(PVector position, PVector velocity, float mass, float radius){
    super(position, velocity, mass, radius);
  }
  
  Exoplanet(PVector position, float mass, float radius){
    super(position, mass, radius);
  }
  
  @Override
  void render(){
    noStroke();
    fill(max(140 - mass, 60));
    //Ellipse takes diameter for 'size', but we store radius instead
    //as radius is far more useful in calculations
    //So *2 just here instead of /2 on every calculation
    ellipse(position.x, position.y, radius*2, radius*2);
  }
}

