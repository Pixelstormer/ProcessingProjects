// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin, 0.8, 45));
  }

  void run() {
    origin.set(width/2,height/2);
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.collision();
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

