class Particle{
  //Physics particle
  
  //Current location
  private PVector location;
  //Current velocity
  private PVector velocity;
  //Emitters associated with this particle
  private List<Emitter> emitters;
  
  private boolean looping;
  private float drag;
  private float weight;
  
  private Renderer renderer;
  
  Particle(PVector location, PVector velocity, List<Emitter> emitters, Renderer renderer, boolean looping, float drag, float weight){
    this.location = location.get();
    this.velocity = velocity.get();
    this.emitters = emitters;
    this.renderer = renderer;
    this.looping = looping;
    this.drag = drag;
    this.weight = weight;
  }
  
  void iter_idlePhysics(){
    this.velocity.add(PVector.mult(GRAVITY,this.weight));
    this.velocity.mult(this.drag);
    this.location.add(this.velocity);
  }
  
  void iter_emitters(){
    if(this.emitters == null) return;
    for(Emitter e : this.emitters){
      
    }
  }
  
  void iter_all(){
    this.iter_idlePhysics();
    this.iter_emitters();
  }
  
  void constrain_to_bounds(){
    this.location.x = constrain(this.location.x,0,width);
    this.location.y = constrain(this.location.y,0,height);
  }
  
  void loop_around_bounds(){
    if(this.location.x < 0) this.location.x = width;
    if(this.location.x > width) this.location.x = 0;
    if(this.location.y < 0) this.location.y = height;
    if(this.location.y > height) this.location.y = 0;
  }
  
  void bounce_off_bounds(){
    if(this.location.x < 0 || this.location.x > width) this.velocity.x *= -1;
    if(this.location.y < 0 || this.location.y > height) this.velocity.y *= -1;
    this.constrain_to_bounds();
  }
  
  void apply_force(PVector force){
    this.velocity.add(PVector.div(force,this.weight));
  }
  
  PVector getVelocity(){
    return this.velocity.get();
  }
  
  PVector getLocation(){
    return this.location.get();
  }
  
  void render(){
    if(this.renderer == null) return;
    this.renderer.render(this.location);
  }
}

