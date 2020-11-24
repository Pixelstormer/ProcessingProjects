class Emitter{
  //Entity which emits particles
  
  //Particles the emitter emits
  //Perpetually cycles through
  private List<EmissionEvent<Particle>> emits;
  //Particle the emitter has emitted
  private List<Particle> emitted;
  
  //Renders the Emitter
  private Renderer renderer;
  
  Emitter(List<EmissionEvent<Particle>> emits, Renderer renderer){
    this.emits = emits;
    this.renderer = renderer;
    this.emitted = new ArrayList<Particle>();
  }
  
  void run(){
    for(EmissionEvent<Particle> e : this.emits){
      e.count();
    }
    
    for(Particle p : this.emitted){
      p.iter_all();
    }
  }
  
  class EmissionEvent<T> extends Timer{
    //Class for storing information about an object that will be emitted
    
    T target;
    
    EmissionEvent(T target){
      this.target = target;
    }
  }
}


