class ShapeNinja extends Minigame{
  private Timer shapeTimer;
  private float shapeInterval;
  private ArrayList<Shape> activeShapes;
  private ArrayList<Shape> toRemove;
  private PVector[] mouseTrail;
  private float cuttingVelocity;
  private final int trailSize = 5;
  
  public ShapeNinja(int wx,int wy,float si, float cv, float firstShapeTime){
    super(wx,wy);
    this.shapeInterval = si;
    this.shapeTimer = new Timer(this.shapeInterval, firstShapeTime);
    this.activeShapes = new ArrayList<Shape>();
    this.toRemove = new ArrayList<Shape>();
    this.mouseTrail = new PVector[this.trailSize];
    this.cuttingVelocity = cv;
    for(int i=0;i<this.trailSize;i++){
      this.mouseTrail[i] = new PVector(0,0);
    }
    super.beginRun();
  }
  
  public void setup(){
    super.setup();
  }
  
  public void draw(){
    background(0);
    
    updateShapes();
  }
  
  private void updateShapes(){
    if(this.shapeTimer.pollStateIntrusive()){
      this.activeShapes.add(
        new Shape(
          new PVector(
            random(width),
            height
          ),
          new PVector(
            random(-2,2),
            random(-6,-8)
          ),
          1,
          0.9,
          12,
          floor(random(4)),
          random(360),
          random(-12,12),
          random(0.97,1.01)
        )
      );
    }
    
    for(Shape s : this.activeShapes){
      s.updatePhysics(new PVector[]{new PVector(0,0.77)});
      if(s.getLocation().y>height+32 || (PVector.dist(new PVector(mouseX,mouseY),s.getLocation())<32 && PVector.dist(this.mouseTrail[this.trailSize-1],this.mouseTrail[this.trailSize-2])>this.cuttingVelocity && this.mousePressed && this.focused)){
        this.toRemove.add(s);
      }
      s.renderShape();
    }
    this.activeShapes.removeAll(this.toRemove);
  }
  
  public void mousePressed(){
    if(this.focused){
      for(int i=0;i<this.trailSize;i++){
        this.mouseTrail[i] = new PVector(mouseX,mouseY);
      }
    }
  }
  
  public void mouseDragged(){
    if(this.focused){
      for(int i=0;i<this.trailSize-1;i++){
        this.mouseTrail[i] = this.mouseTrail[i+1].get();
      }
      this.mouseTrail[this.trailSize-1] = new PVector(mouseX,mouseY);
      stroke(240);
      strokeWeight(3);
      noFill();
      beginShape();
      for(PVector p : this.mouseTrail){
        vertex(p.x,p.y);
      }
      endShape();
    }
  }
  
  public void keyPressed(){
    exit();
  }
  
  private class Shape{
    private PVector location;
    private PVector velocity;
    private float drag;
    private float scalar;
    private float mass;
    private float angle;
    private float angularVelocity;
    private float angularDrag;
    private int type;
    
    public Shape(PVector l, PVector v, float d, float s, float m, int t, float a, float av, float ad){
      this.location = l.get();
      this.velocity = v.get();
      this.drag = d;
      this.scalar = s;
      this.mass = m;
      this.type = t;
      this.angle = a;
      this.angularVelocity = av;
      this.angularDrag = ad;
    }
    
    public PVector getLocation(){
      return this.location.get();
    }
    
    public void updatePhysics(PVector[] forces){
      PVector acceleration = new PVector(0,0);
      for(PVector p : forces){
        acceleration.add(p);
      }
      acceleration.div(this.mass);
      
      this.velocity.add(acceleration);
      this.velocity.mult(this.drag);
      
      this.location.add(PVector.mult(velocity,this.scalar));
      
      this.angularVelocity*=this.angularDrag;
      this.angle+=this.angularVelocity;
    }
    
    public void renderShape(){
      pushMatrix();
      strokeWeight(3);
      translate(this.location.x,this.location.y);
      rotate(radians(this.angle));
      switch(this.type){
        case 0:
          //Triangle
          stroke(85,222,85);
          fill(120,200,120);
          triangle(0,-16,-16,16,16,16);
          break;
        case 1:
        default:
          //Square
          stroke(85,85,222);
          fill(120,120,200);
          rectMode(CENTER);
          rect(0,0,32,32);
          break;
        case 2:
          //Circle
          stroke(222,85,222);
          fill(200,120,200);
          ellipse(0,0,32,32);
          break;
        case 3:
          //Star
          stroke(222,222,85);
          fill(200,200,120);
          beginShape();
          vertex(0,-22);
          vertex(-5,-8);
          vertex(-16,-8);
          vertex(-8,0);
          vertex(-12,16);
          vertex(0,8);
          vertex(12,16);
          vertex(8,0);
          vertex(16,-8);
          vertex(5,-8);
          endShape(CLOSE);
          break;
      }
      popMatrix();
    }
  }
}


