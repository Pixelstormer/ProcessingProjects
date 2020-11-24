class Observer {
  //Class for observing and manipulating tree nodes
  //Has a strong correlation with GuiNodes

  //Represents a given point that is currently under observation
  private PVector spotlight;

  //Reference to a given node that is currently of interest
  private Node subject;

  //Reference to a given GuiNode that is currently of interest
  private GuiNode guiTarget;

  //If the observer currently expects it is touching the subject node
  private boolean touchingSubject;

  //If the observer is currently interacting with the subject node
  private boolean isInteracting;

  Observer() {
    this.spotlight = new PVector(0, 0);
    this.subject = null;
  }

  Observer(PVector spotlight) {
    this.spotlight = spotlight.get();
    this.subject = null;
  }

  void setSpotlight(PVector newPos) {
    this.spotlight = newPos.get();
  }

  PVector getSpotlight() {
    return this.spotlight.get();
  }

  void offsetSpotlight(PVector offset) {
    this.spotlight.add(offset);
  }

  void setSubject(Node subject) {
    if (subject == null) {
      if (this.subject != null) {
        for (GuiNode n : guiNodes) {
          n.setToDisappearInto(this.subject);
          n.setTimer(150);
        }
      }
    } else {
      subject.setFill(100);
    }
    if (this.subject!=null) this.subject.setFill(40);
    this.subject = subject;
  }

  void beginInteracting() {
    this.isInteracting = true;
  }

  void stopInteracting() {
    this.isInteracting = false;
  }

  void setInteracting(boolean interacting) {
    this.isInteracting = interacting;
  }

  Node getSubject() {
    return this.subject;
  }

  //If the observer is actually touching the subject node
  boolean touchingSubject() {
    if (this.getSubject()==null) return false;
    return PVector.dist(this.getSpotlight(), this.getSubject().location())<=this.getSubject().getSize();
  }

  //Is the current observer's location overlapping
  //with a non-zero number of nodes in the provided list?
  boolean isColliding(List<Node> toCheck) {
    for (Node n : toCheck) {
      if (n.investigativeCollide(this.getSpotlight()) != null) return true;
    }
    return false;
  }

  boolean isInteracting() {
    return this.isInteracting;
  }

  boolean hasSelected() {
    return this.getSubject() != null;
  }
  
  boolean hasGuiTarget() { 
    return this.getGuiTarget() != null;
  }

  Node getColliding(List<Node> toCheck) {
    for (Node n : toCheck) {
      Node result = n.investigativeCollide(this.getSpotlight());
      if (result!=null) return result;
    }
    return null;
  }

  void setGuiTarget(GuiNode target) {
    this.guiTarget = target;
    this.guiTarget.setFill(100);
  }

  void deselectGuiTarget() {
    if (this.guiTarget == null) return;
    this.guiTarget.setFill(40);
    this.guiTarget = null;
  }

  GuiNode getGuiTarget() {
    return this.guiTarget;
  }

  void invokeGuiTarget() {
    try {
      this.guiTarget.invokeAction(this.getSubject());
    }
    catch(Exception e) {
      println(String.format("Encountered '%s' when attempting to invoke the registered method of GuiNode '%s'.", e.toString(), this.guiTarget.getText()));
      e.printStackTrace();
    }
  }

  void updateGuiNodeCollision() {
    for (GuiNode n : guiNodes) {
      if (PVector.dist(n.location(), this.getSpotlight()) <= n.getSize()/2) {
        this.setGuiTarget(n);
        updateHintText(n.getHintText());
        return;
      }
    }
    this.deselectGuiTarget();
    updateHintText("");
  }
}

