public abstract class Minigame extends PApplet{
  private int x,y;
  public Minigame(int x, int y){
    super();
    this.x=x;
    this.y=y;
  }
  public void setup(){
    size(this.x,this.y);
    this.frame.setResizable(true);
  }
  public abstract void draw();
  public void beginRun(){
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
}

