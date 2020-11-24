class MoverAI{
  private Mover host;
  private Goal home;
  private Objective currentObjective;
  private boolean carryingObjective;
  
  MoverAI(Mover host, Goal home){
    this.host = host;
    this.home = home;
    carryingObjective = false;
  }
  
  void iterate(){
    if(currentObjective == null){
      currentObjective = game.findClosestGameObjectOfType(host.position(), Objective.class);
      host.updateTarget(currentObjective.position());
    }
    
    if(home == null){
      home = game.findClosestGameObjectOfType(host.position(), Goal.class);
    }
    
    host.update();
    host.render();
  }
  
  void updateTarget(){
    if(carryingObjective){
      carryingObjective = false;
      home.addScore();
      currentObjective = findNewObjective();
      host.updateTarget(currentObjective.position());
    }
    else{
      carryingObjective = true;
      host.updateTarget(home.position());
      currentObjective.reposition();
    }
  }
  
  Objective findNewObjective(){
    return game.findClosestGameObjectOfType(host.position(), Objective.class);
  }
  
  Goal findNewHome(){
    return game.findClosestGameObjectOfType(host.position(), Goal.class);
  }
}

