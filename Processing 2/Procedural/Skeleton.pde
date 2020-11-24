class Skeleton {
  //Responsible for handling a system of joints
  //Ie. construction, manipulation, rendering
  //The joints sort the physics out amongst themselves(?)
  
  private final ArrayList<Joint> joints;

  Skeleton(List<Joint> joints) {
    this.joints = new ArrayList<Joint>();
    this.joints.addAll(joints);
  }

  Skeleton() {
    joints = new ArrayList<Joint>();
  }
  
  Skeleton(int amt){
    joints = new ArrayList<Joint>(amt);
  }
  
  void updateAll(){
    for(Joint j : joints){
      j.update();
    }
    for(Joint j : joints){
      j.applyUpdate();
    }
  }
  
  void render(){
    ArrayList<Entry<Joint, Joint>> rendered = new ArrayList<Entry<Joint, Joint>>(joints.size());
    joints:
    for(Joint j : joints){
      connections:
      for(Entry<Joint, Spring> e : j.getConnectionSet()){
        Joint other = e.getKey();
        Spring s = e.getValue();
        rendered:
        for(Entry<Joint, Joint> r : rendered){
          if(r.getKey().equals(other) && r.getValue().equals(j))
            continue connections;
        }
        stroke(255);
        noFill();
        strokeWeight(s.getK());
        line(j.position().x, j.position().y, other.position().x, other.position().y);
        rendered.add(new SimpleEntry<Joint, Joint>(j, other));
      }
      j.renderPoint();
    }
  }
  
  void applyForce(int index, PVector force){
    if(index<0 || index>=joints.size())
      throw new IndexOutOfBoundsException(String.format("Attempted to apply a vector force (%s) to the non-existent joint at illegal index %s. Index is out of array bounds.", force, index));
    joints.get(index).applyForce(force);
  }
  
  Joint getJoint(int index){
    if(index<0 || index>=joints.size())
      throw new IndexOutOfBoundsException(String.format("Attempted to retrieve non-existent joint at illegal index %s. Index is out of array bounds.", index));
    return joints.get(index);
  }
  
  int jointAmount(){
    return joints.size();
  }
  
  //Adds a single new joint to the system
  //The joint is automatically connected to the closest other joint, if any
  //Given spring settings are used for this connection
  void addJoint(PVector position, float mass, float drag, float friction, PVector gravity, boolean hasGravity, float k, float equilibrium){
    Joint closest = closestTo(position);
    Joint added = new Joint(position, mass, drag, friction, gravity, hasGravity);
    
    joints.add(added);
    
    if(closest == null)
      return;
    
    //Connect
    added.connectTo(closest, new Spring(k, equilibrium));
  }
  
  void addJoint(PVector position, float mass, float drag, float friction, PVector gravity, boolean hasGravity, Spring connector){
    Joint closest = closestTo(position);
    Joint added = new Joint(position, mass, drag, friction, gravity, hasGravity);
    
    joints.add(added);
    
    //No others, no need to connect
    if(closest == null)
      return;
    
    //Connect
    added.connectTo(closest, connector);
  }
  
  void addConnection(int firstIndex, int secondIndex, float k, float equilibrium){
    addConnection(firstIndex, secondIndex, new Spring(k, equilibrium));
  }
  
  void addConnection(int firstIndex, int secondIndex, Spring with){
    if(firstIndex<0 || firstIndex>=joints.size() || secondIndex<0 || secondIndex>=joints.size())
      throw new IndexOutOfBoundsException(String.format("Attempted to create a connection with a non-existent joint. One or both of the indexes %s and %s are out of array bounds.", firstIndex, secondIndex));
    
    joints.get(firstIndex).connectTo(joints.get(secondIndex), with);
  }
  
  //Returns the joint that is closest to the given positions
  //Or null if no joints exist
  Joint closestTo(PVector position){
    if(joints.size() == 1)
      return joints.get(0);
    if(joints.size() == 0)
      return null;
    
    Joint currentClosest = null;
    float closestDistance = Float.POSITIVE_INFINITY;
    for(Joint j : joints){
      if(PVector.dist(j.position(), position) < closestDistance){
        currentClosest = j;
        closestDistance = PVector.dist(j.position(), position);
      }
    }
    return currentClosest;
  }

  //Point masses
  class Joint{
    private final PVector position;
    private final PVector velocity;
    //Gravity can be any direction and magnitude as a vector
    private final PVector gravity;
    private final float mass;
    //Friction is used for bounding box collision
    private final float frictionCoefficient;
    private final float dragCoefficient;
    private boolean hasGravity;
    //If a joint is locked it undergoes no physics updates and cannot be moved
    private boolean isLocked;

    //A list of joints this joint is connected to,
    //and the spring that makes up the connection
    private final HashMap<Joint, Spring> connections;

    private final static int MAXIMUM_CONNECTIONS = Integer.MAX_VALUE;

    Joint(PVector position, float mass, float drag, float friction, PVector gravity, boolean hasGravity) {
      this.position = position.get();
      this.mass = mass;
      this.gravity = gravity.get();
      this.hasGravity = hasGravity;
      dragCoefficient = drag;
      frictionCoefficient = friction;
      velocity = new PVector(0,0);
      connections = new HashMap<Joint, Spring>();
    }
    
    void update(){
      //Only apply physics if not locked
      if(!isLocked){
        //Apply gravity
        if(hasGravity)
          velocity.add(PVector.mult(gravity, mass));
        
        //Apply drag
        velocity.add(PVector.mult(velocity, -dragCoefficient));
      }
      
      //Apply spring forces
      for(Entry<Joint, Spring> e : connections.entrySet()){
        //Collect variables
        Joint j = e.getKey();
        Spring s = e.getValue();
        
        //Retrieve resulting force
        float force = s.getForce(PVector.dist(position, j.position()));
        
        //Apply force to this spring
        PVector direction = PVector.sub(j.position(),position);
        direction.setMag(force);
        applyForce(direction);
        
        //Apply force to other spring
        //Other spring already does this when it performs its own update
//        direction.mult(-1);
//        s.applyForce(direction);
      }
    }
    
    void applyUpdate(){
      //If locked, this joint cannot move, so return immedietly
      if(isLocked)
        return;
      
      //Update position
      position.add(PVector.div(velocity, mass));
      //position.add(velocity);
      limitToBounds(screenBounds);
    }
    
    void limitToBounds(BoundingBox bounds){
      if(position.x < bounds.leftEdgeX){
        position.x = bounds.leftEdgeX;
        velocity.x *= -bounds.elasticity;
      }
      if(position.x > bounds.rightEdgeX){
        position.x = bounds.rightEdgeX;
        velocity.x *= -bounds.elasticity;
      }
      if(position.y < bounds.topEdgeY){
        position.y = bounds.topEdgeY;
        velocity.y *= -bounds.elasticity;
      }
      if(position.y > bounds.bottomEdgeY){
        position.y = bounds.bottomEdgeY;
        velocity.y *= -bounds.elasticity;
      }
    }
    
    PVector applyForce(PVector force){
      //Cannot be moved if locked
      if(!isLocked)
        velocity.add(PVector.div(force, mass));
      return velocity.get();
    }
    
    PVector predictForce(PVector force){
      if(isLocked)
        return new PVector(0,0);
      return PVector.div(force, mass);
    }
    
    PVector position(){
      return position.get();
    }
    
    Set<Entry<Joint, Spring>> getConnectionSet(){
      return connections.entrySet();
    }
    
    void connectTo(Joint other, Spring with){
      //Already connected to this joint
      if(connections.containsKey(other)){
        //Already using this spring
        if(connections.get(other).equals(with)){
          //No action needed
          println("Cannot create an exact duplicate connection.");
          return;
        }
        //Want to replace the joint connection with a new spring
        else{
          println("Replacing spring in this connection.");
          connections.put(other, with);
          other.connectTo(this, with);
        }
      }
      //New joint, so create connection
      else{
        println("Creating a new connection.");
        connections.put(other, with);
        other.connectTo(this, with);
      }
    }
    
    void renderPoint(){
      noStroke();
      fill(160);
      ellipse(position.x, position.y, 5, 5);
    }
  }
  
  //Springs connecting joints
  //Follows Hooke's Law
  class Spring {

    //Spring constant
    private final float k;

    //Ideal length the spring would like to be at
    private final float equilibrium;

    Spring(float k, float equilibrium) {
      this.k = k;
      this.equilibrium = equilibrium;
    }

    //Returns the restoring force exerted for a given length
    float getForce(float springLength) {
      return k*(springLength-equilibrium);
    }
    
    float getK(){
      return k;
    }
    
    float getEquilibrium(){
      return equilibrium;
    }
  }
}

