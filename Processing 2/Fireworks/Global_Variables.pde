float deltaTime;
float deltaTimer = 0;
boolean DELTATIME = true;

PVector rocketVelocityRange = new PVector(750,1000);
PVector rocketAngleRange    = new PVector(-24,24);
PVector rocketGravRange     = new PVector(20,30);
PVector rocketLaunchRange   = new PVector(150,350);
PVector rocketThrustRange   = new PVector(2,12);
PVector rocketParticleRange = new PVector(12,24);
PVector rocketLimitRange    = new PVector(-200,400);

PVector particleSpeedRange  = new PVector(16,18);
PVector particleDragRange   = new PVector(1.1,1.24);
PVector particleLimitRange  = new PVector(0.02,1);
PVector particleAngleRange  = new PVector(-12,12);
PVector particleSizeRange   = new PVector(5,10);

ArrayList<Firework> activeRockets;
ArrayList<Firework> rocketsToRemove;

ArrayList<Particle> activeParticles;
ArrayList<Particle> particlesToRemove;

Launcher l;
