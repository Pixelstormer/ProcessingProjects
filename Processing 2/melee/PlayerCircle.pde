class PlayerCircle extends BasicCircle{
  //Directly controllable by user
  
  private final HashMap<Integer, Boolean> inputs;
  
  private float lookAngle;
  private final float visorWidth;
  private final float halfVisorWidth;
  private final float walkSpeed;
  
  PlayerCircle(PVector position, PVector velocity, PVector gravity, float mass, float dragCoefficient, float elasticity, float friction, float diameter, float visorWidth, float walkSpeed){
    super(position, velocity, gravity, mass, dragCoefficient, elasticity, friction, diameter);
    lookAngle = 0;
    this.visorWidth = visorWidth;
    halfVisorWidth = visorWidth/2;
    inputs = new HashMap<Integer, Boolean>();
    this.walkSpeed = walkSpeed;
  }
  
  PlayerCircle(PVector position, PVector gravity, float mass, float drag, float elasticity, float friction, float diameter, float visorWidth, float walkSpeed){
    super(position, gravity, mass, drag, elasticity, friction, diameter);
    lookAngle = 0;
    this.visorWidth = visorWidth;
    halfVisorWidth = visorWidth/2;
    inputs = new HashMap<Integer, Boolean>();
    this.walkSpeed = walkSpeed;
  }
  
  void setInput(int input, boolean state){
    inputs.put(input, state);
  }
  
  void setInput(char input, boolean state){
    setInput(int(input), state);
  }
  
  void activateInput(int input){
    inputs.put(input, true);
  }
  
  void activateInput(char input){
    activateInput(int(input));
  }
  
  void deactivateInput(int input){
    inputs.put(input, false);
  }
  
  void deactivateInput(char input){
    deactivateInput(int(input));
  }
  
  boolean getInputState(int input){
    return ((inputs.get(input)==null) ? false : inputs.get(input));
  }
  
  boolean getInputState(char input){
    return getInputState(int(input));
  }
  
  void updateLookAngle(PVector lookTowards){
    lookAngle = degrees(PVector.lerp(PVector.fromAngle(radians(lookAngle)), PVector.sub(lookTowards, position).normalize(null), 0.2).heading());
  }
  
  void applyInputForces(){
    PVector inputDir = new PVector(0,0);
    if(getInputState('w') || getInputState('W'))
      inputDir.y--;
    if(getInputState('s') || getInputState('S'))
      inputDir.y++;
    if(getInputState('a') || getInputState('A'))
      inputDir.x--;
    if(getInputState('d') || getInputState('D'))
      inputDir.x++;
    inputDir.setMag(walkSpeed);
    applyForce(inputDir);
  }
  
  @Override
  void render(){
    noFill();
    stroke(255);
    strokeWeight(3);
    circle(position.x, position.y, diameter);
    renderVisor();
  }
  
  private void renderVisor(){
    noStroke();
    fill(255);
    arc(position.x, position.y, diameter, diameter, radians(lookAngle-visorWidth), radians(lookAngle+visorWidth));
  }
}

