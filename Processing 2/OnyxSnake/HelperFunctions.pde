void square(float x, float y, float w){
  rect(x, y, w, w);
}

void square(PVector pos, float w){
  square(pos.x, pos.y, w);
}

PVector getWithMag(PVector original, float newMag){
  return PVector.mult(original.normalize(null), newMag);
}

float angleTo(PVector from, PVector to){
  return degrees(PVector.sub(to, from).normalize(null).heading());
}

