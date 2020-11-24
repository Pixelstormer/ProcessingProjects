class Atom{
  ArrayList<NucleiParticle> Nucleus;
  ArrayList<Electron[]> Shells;
  light Ambience;
  
  PVector Location;
  
  float firstShellDistance;
  float shellDistance;
  
  Atom(PVector Location, int AtomicNumber, int AtomicWeight){
    Nucleus = new ArrayList<NucleiParticle>();
    Shells = new ArrayList<Electron[]>();
    this.Location = Location.get();
//    this.firstShellDistance = firstShellDistance;
    this.firstShellDistance = sqrt(AtomicWeight)*25 + 15;
//    this.shellDistance = shellDistance;
    this.shellDistance = this.firstShellDistance/2;
    
    Shells.add(new Electron[2]);
    if(AtomicNumber>2){
      for(int i=0;i<=ceil((AtomicNumber-3)/8);i++){
        Shells.add(new Electron[8]);
      }
    }
    
    int shellNo = 0;
    float angle = 0;
    
    int innerShellElectrons = (AtomicNumber)-((AtomicNumber-2)%8);
    float outerShellAngle = 360/8;
    if(AtomicNumber>2 && (AtomicNumber-2)%8!=0){
      outerShellAngle = 360/((AtomicNumber-2)%8);
    }
    
    for(int i=1;i<=AtomicNumber;i++){
      Nucleus.add(new NucleiParticle(true,new PVector(width/2,height/2), 25));
//      Nucleus.add(new NucleiParticle(true,new PVector(random(width),random(height))));
//      Nucleus.add(new NucleiParticle(true, new PVector(random(width/2-50,width/2+60),random(height/2-50,height/2+50))));
      Shells.get(shellNo)[i%((shellNo==0)?2:8)] = new Electron(PVector.add(this.Location,PVector.mult(PVector.fromAngle(radians(angle)),(this.firstShellDistance + this.shellDistance*shellNo))),15);
      if((shellNo==0 && i>1)||(shellNo>0 && i-2>0 && (i-2)%8==0)){
        shellNo++;
        angle = 0;
      }
      if(i>innerShellElectrons){
        angle+=outerShellAngle;
      }
      else{
        angle+=(shellNo==0) ? 360/2 : 360/8;
      }
    }
    
    for(int i=0;i<AtomicWeight-AtomicNumber;i++){
      Nucleus.add(new NucleiParticle(false, new PVector(width/2,height/2), 25));
    }
    
    this.Ambience = new light(int(this.Location.x),int(this.Location.y),int(this.firstShellDistance + this.shellDistance*shellNo + 15*shellNo)*2+400,35,0);
  }
  
  public void Render(){
    this.RenderAmbience();
    this.RenderNucleus();
    this.RenderElectrons();
  }
  
  private void RenderNucleus(){
    for(NucleiParticle n : this.Nucleus){
      n.Render();
    }
  }
  
  private void RenderElectrons(){
    for(Electron[] s : this.Shells){
      for(Electron e : s){
        if(e!=null){
          e.Render();
        }
      }
    }
  }
  
  private void RenderAmbience(){
    this.Ambience.render();
  }
  
  public void Update(){
    this.UpdateNucleus();
    this.UpdateElectrons();
  }
  
  private void UpdateNucleus(){
    for(NucleiParticle n : this.Nucleus){
      n.moveTowards(this.Location);
    }
    ArrayList<NucleiParticle> others = (ArrayList<NucleiParticle>)this.Nucleus.clone();
    for(NucleiParticle n : this.Nucleus){
      others.remove(n);
      n.doCollision(this.Nucleus);
    }
    
//    for(NucleiParticle n : this.Nucleus){
//      for(NucleiParticle N : this.Nucleus){
//        n.collideWithCircle(N.Location,25);
//      }
//    }
  }
  
  private void UpdateElectrons(){
    int shellNumber = 0;
    for(Electron[] s : this.Shells){
      for(Electron e : s){
        if(e!=null){
          e.rotateAround(this.Location, this.firstShellDistance + this.shellDistance*shellNumber);
        }
      }
      shellNumber++;
    }
  }
  
  public void MoveTo(PVector location){
    PVector offsetCaused = PVector.sub(location,this.Location);
    this.Location = location.get();
    this.Ambience.move(int(this.Location.x+GlobalOffset.x),int(this.Location.y+GlobalOffset.y));
    
    for(NucleiParticle n : this.Nucleus){
      n.offsetBy(offsetCaused);
    }
    
    for(Electron[] s : this.Shells){
      for(Electron e : s){
        if(e!=null){
          e.offsetBy(offsetCaused);
        }
      }
    }
  }
}

