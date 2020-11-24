class Grappler{
  //Grappler acts as the brain and controller
  //Tells core and grapples what to do
  private final Core core;
  private final List<Grapple> grapples;
  private final int grappleCount;
  private final List<Hook> hooks;
  private final PVector targetLocation;
  private final float strength;
  private PVector gravity;
  
  Grappler(PVector position, float coreStrength, float coreMass, float coreDrag, int grappleCount, float grappleMass, float grappleDrag, float grappleStrength, float grappleTension, float grappleGrip){
    core = new Core(position, coreMass, coreDrag);
    grapples = new ArrayList<Grapple>(grappleCount);
    this.grappleCount = grappleCount;
    while(grapples.size() < grappleCount)
      grapples.add(new Grapple(core, grappleMass, grappleDrag, grappleStrength, grappleTension, grappleGrip));
    hooks = new ArrayList<Hook>();
    targetLocation = position.get();
    gravity = new PVector(0, 0);
    strength = coreStrength;
  }
  
  Grappler(PVector position, float coreStrength, float coreMass, float coreDrag, int grappleCount, float grappleMass, float grappleDrag, float grappleStrength, float grappleTension, float grappleGrip, List<Hook> hooks){
    this(position, coreStrength, coreMass, coreDrag, grappleCount, grappleMass, grappleDrag, grappleStrength, grappleTension, grappleGrip);
    supplyHooks(hooks);
  }
  
  void replaceHooks(List<Hook> newHooks){
    hooks.clear();
    hooks.addAll(newHooks);
    resetGrapples();
    updateHookAssignments();
  }
  
  void resetGrapples(){
    for(Grapple g : grapples)
      g.resetTarget();
  }
  
  void supplyHooks(List<Hook> hooks){
    this.hooks.addAll(hooks);
  }
  
  void supplyHook(Hook hook){
    hooks.add(hook);
  }
  
  void update(){
    updateHookAssignments();
    PVector dir = PVector.sub(targetLocation, core.getPosition());
    dir.setMag(min(getAttachedGrapples() * strength, dir.mag() * strength));
    core.applyForce(dir);
    core.update(gravity);
    for(Grapple g : grapples)
      g.update(gravity);
  }
  
  PVector getCorePosition(){
    return core.getPosition();
  }
  
  void sortHooksByDistanceFrom(PVector point){
    Collections.sort(hooks, new DistanceComparator(point));
  }
  
  void updateHookAssignments(){
    //sortHooksByDistanceFrom(core.getPosition());
    for(int i=0; i<grapples.size(); i++){
      grapples.get(i).findTarget(hooks);
    }
  }
  
  private int getAttachedGrapples(){
    int count = 0;
    for(Grapple g : grapples){
      if(g.isAttached())
        count++;
    }
    return count;
  }
  
  void setTarget(PVector to){
    targetLocation.set(to.x, to.y);
  }
  
  void setTarget(float x, float y){
    targetLocation.set(x, y);
  }
  
  void setGravity(PVector to){
    gravity = to.get();
  }
  
  void setGravityToReference(PVector to){
    gravity = to;
  }
  
  void render(){
    core.render();
    for(Grapple g : grapples)
      g.render();
  }
  
  class Core extends MassPoint{
    //Core has the actual physics calculations
    private final float shade = 160;
    private final float radius = 15;
    
    private final List<Grapple> grapples;
    
    Core(PVector position, float mass, float drag){
      super(position, mass, drag);
      grapples = new ArrayList<Grapple>();
    }
    
    @Override
    void update(PVector gravity){
      updateVelocity(gravity);
      //Extra stuff here
      updatePosition();
      if(position.x < radius){
        position.x = radius;
        velocity.x *= -drag;
      }
      
      if(position.x > width-radius){
        position.x = width-radius;
        velocity.x *= -drag;
      }
      
      if(position.y < radius){
        position.y = radius;
        velocity.y *= -drag;
      }
      
      if(position.y > height-radius){
        position.y = height-radius;
        velocity.y *= -1;
      }
    }
    
    void render(){
      noStroke();
      fill(shade);
      ellipse(position.x, position.y, radius*2, radius*2);
    }
  }
  
  class Grapple extends MassPoint{
    //Grapple apply forces to core to move it around
    private final float shade = 140;
    private final float lineWeight = 3;
    private final float headWeight = 4;
    private final float headSize = 10;
    
    //Core that this grapple pulls
    private final Core core;
    //How strong the grapple pulls towards target hook
    private final float strength;
    //How strong the grapple pulls towards core (Spring constant)
    private final float tension;
    //How much force the grapple can resist before it loses its grip on the hook
    private final float grip;
    //Is the grapple head holding onto a hook
    private boolean isAttached;
    //Target hook grapple tries to reach
    private Hook target;
    
    Grapple(Core core, float mass, float drag, float strength, float tension, float grip){
      super(core.getPosition(), mass, drag);
      this.core = core;
      this.strength = strength;
      this.tension = tension;
      this.grip = grip;
      resetTarget();
    }
    
    void setTarget(Hook to){
      if(to == target)
        return;
      if(target != null)
        target.setBeingUsed(false);
      target = to;
      to.setBeingUsed(true);
      isAttached = false;
    }
    
    void findTarget(List<Hook> from){
      if(isAttached && !anyTrue(inputs))
          return;
      for(Hook h : from){
        if(h.beingUsed())
          continue;
        if(target == null || PVector.dist(core.getPosition(), target.pos()) > PVector.dist(core.getPosition(), h.pos())){
          setTarget(h);
          return;
        }
      }
    }
    
    void resetTarget(){
      isAttached = false;
      target = null;
    }
    
    @Override
    void update(PVector gravity){
      applyAttachedPull();
        
      updateVelocity(gravity);
      
      applyCorePull();
      
      applyTargetPull();
      
      updatePosition();
    }
    
    @Override
    protected void updatePosition(){
      if(velocity.mag() > grip){
        isAttached = false;
      }
      if(isAttached)
        return;
      super.updatePosition();
    }
    
    private void applyAttachedPull(){
      if(!isAttached)
        return;
      
      PVector dir = PVector.sub(position, core.getPosition());
      dir.setMag(strength);
      core.applyForce(dir);
    }
    
    private void applyCorePull(){
      //Grapple behaves like a spring between head and core, with equilibrium length 0
      PVector coreDirection = PVector.sub(core.getPosition(), position);
      float coreDist = abs(coreDirection.mag());
      float coreForce = tension * coreDist;
      coreDirection.setMag(coreForce);
      applyForce(coreDirection);
    }
    
    private void applyTargetPull(){
      if(target == null || isAttached)
        return;
        
      PVector dir = PVector.sub(target.pos(), position);
      float dist = dir.mag();
      dir.setMag(min(strength, dist));
      applyForce(dir);
      
      if(dist <= Hook.size){
        isAttached = true;
      }
    }
    
    boolean isAttached(){
      return isAttached;
    }
    
    void render(){
      stroke(shade);
      strokeWeight(lineWeight);
      noFill();
      line(core.getPosition().x,core.getPosition().y, position.x, position.y);
      if(isAttached)
        fill(shade);
      strokeWeight(headWeight);
      ellipse(position.x, position.y, headSize, headSize);
    }
  }
}

