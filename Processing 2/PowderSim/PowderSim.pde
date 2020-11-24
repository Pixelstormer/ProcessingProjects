import java.util.Map.Entry;
import java.util.Iterator;
import java.awt.Graphics2D;
import java.awt.RenderingHints;

final String NUMERIC_ALPHABET="0123456789";
final int SCALAR = 8;
final int X_SIZE = 840;
final int Y_SIZE = 560;
final int X_SIZE_SCALED=X_SIZE/SCALAR;
final int Y_SIZE_SCALED=Y_SIZE/SCALAR;
final PVector GRAVITY = new PVector(0, 1);

boolean looping = false;
PVector positiveBoundsInset = new PVector(1, 1);
PVector negativeBoundsInset = new PVector(2, 2);

int brushSize = 6;
int hardParticleLimit = 6000;
int particleIndex;

HashMap<PVector, Particle> Space;
HashMap<PVector, Particle> Pending;

PGraphics Screen;

void setup() {
  size(X_SIZE, Y_SIZE);
  //frame.setResizable(true);

  Screen = createGraphics(X_SIZE_SCALED, Y_SIZE_SCALED);
  Space = new HashMap<PVector, Particle>();
  Pending = new HashMap<PVector, Particle>();
}

void draw() {
  background(0);

  PollInput();

  InsertPending();

  Iterate();

  Render(Screen);
}

void InsertPending() {
  Space.putAll(Pending);
  Pending.clear();
}

void Iterate() {
  final Iterator i = Space.entrySet().iterator();
  while (i.hasNext ()) {
    Entry<PVector, Particle> e = (Entry<PVector, Particle>)i.next();
    HashMap<PVector, Particle> neighbours = new HashMap<PVector, Particle>();
    PVector intendedMovement = e.getValue().pollGravityResult(GRAVITY);
    for (int x=-1; x<=1; x++) {
      for (int y=-1; y<=1; y++) {
        if (x!=0||y!=0) {
          Particle p = Space.get(limitToBounds(PVector.add(e.getKey(), new PVector(x, y))));
          if (p==null) {
            p=Pending.get(limitToBounds(PVector.add(e.getKey(), new PVector(x, y))));
          }
          neighbours.put(new PVector(x, y), p);
        }
      }
    }

    PVector n = limitToBounds(PVector.add(e.getKey(), e.getValue().pollCollisionResult(intendedMovement, neighbours)));
    if (!e.getValue().pollToDestroy()) {
      Pending.put(n, e.getValue());
    }
  }
  Space.clear();
}

void Render(PGraphics renderer) {
  Graphics2D g2d = ((PGraphicsJava2D)g).g2;
  g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_NEAREST_NEIGHBOR);
  renderer.beginDraw();
  renderer.background(0);
  for (PVector p : Pending.keySet ()) {
    Pending.get(p).Render(p.x, p.y, renderer);
  }
  renderer.endDraw();
  imageMode(CENTER);
  image(renderer, width/2, height/2, width, height);
}

PVector limitToBounds(PVector input) {
  if (looping) {
    float nx = input.x;
    float ny = input.y;
    if (input.x<positiveBoundsInset.x) {
      nx = X_SIZE_SCALED-negativeBoundsInset.x;
    }
    if (input.x>X_SIZE_SCALED-negativeBoundsInset.x) {
      nx = positiveBoundsInset.x;
    }
    if (input.y<positiveBoundsInset.y) {
      ny = Y_SIZE_SCALED-negativeBoundsInset.y;
    }
    if (input.y>Y_SIZE_SCALED-negativeBoundsInset.y) {
      ny = positiveBoundsInset.y;
    }
    return new PVector(nx, ny);
  }
  return new PVector(constrain(input.x, positiveBoundsInset.x, X_SIZE_SCALED-negativeBoundsInset.x), constrain(input.y, positiveBoundsInset.y, Y_SIZE_SCALED-negativeBoundsInset.y));
}

Particle getSelectedParticle() {
  switch(particleIndex) {
  case 2:
    return new Water();
  case 3:
    return new Fire();
  case 4:
    return new Ice();
  case 5:
    break;
  case 6:
    break;
  case 7:
    break;
  case 8:
    break;
  case 9:
    break;
  }
  return new Powder();
}

PVector properConstrainMagnitude(PVector p, float lb, float ub){
  return new PVector(constrain(p.x,lb,ub),constrain(p.y,lb,ub));
}

PVector add(PVector a, PVector b){
  PVector result = new PVector(a.x+b.x,a.y+b.y,a.z+b.z);
  println("Added %s to %s resulting in %s",a,b,result);
  return result;
}

boolean vectorEquals(PVector a, PVector b) {
  return a.x==b.x&&a.y==b.y&&a.z==b.z;
}

void PollInput() {
  if (mousePressed) {
    for (float x=-brushSize/2; x<brushSize/2; x++) {
      for (float y=-brushSize/2; y<brushSize/2; y++) {
        PVector target = new PVector(x+int(mouseX/SCALAR), y+int(mouseY/SCALAR));
        if(target.x>positiveBoundsInset.x-1&&target.x<X_SIZE_SCALED-(negativeBoundsInset.x-1)&&target.y>positiveBoundsInset.y-1&&target.y<Y_SIZE_SCALED-(negativeBoundsInset.y-1)){
          if (PVector.dist(target, new PVector(int(mouseX/SCALAR), int(mouseY/SCALAR)))<brushSize/2 && Pending.size()+Space.size()<hardParticleLimit) {
            if (Space.get(target)==null&&Pending.get(target)==null) {
              float chance = random(100);
              Pending.put(target, getSelectedParticle());
            }
          }
        }
      }
    }
  }
}

void keyPressed() {
  if (NUMERIC_ALPHABET.indexOf(key)!=-1) {
    particleIndex=int(str(key));
  }
}

void mouseWheel(MouseEvent event){
  brushSize = constrain(brushSize+event.getCount()*-1,2,16);
}

