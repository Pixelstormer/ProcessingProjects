class Path{
  ArrayList<PVector> points;

  Path() {
    points=new ArrayList<PVector>();
  }

  void addPoint(float x, float y) {
    points.add(new PVector(x, y));
  }

  void removePoint(float x, float y) {
    for (int i = points.size()-1; i >=0; i--) {
      if (dist(x, y, points.get(i).x, points.get(i).y)<40) {
        points.remove(i);
        break;
      }
    }
    if (points.size()<1) {
      removeAll();
    }
  }

  void render() {
    noFill();
    stroke(255);
    strokeWeight(20);
    beginShape();
    for (PVector v : points) {
      vertex(v.x, v.y);
    }
    endShape();

    stroke(0);
    strokeWeight(1);
    beginShape();
    for (PVector v : points) {
      vertex(v.x, v.y);
    }
    endShape();
  }
}

