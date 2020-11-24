class Node {
  //Target point where this node is moving towards
  protected PVector location;
  //Point where this node is rendered
  protected PVector renderLocation;
  //Flavour text to display
  protected String text;
  //Angle around which this node will distribute its children
  private float alignAngle;
  //Size which the node will be rendered at
  protected float renderSize;
  //Target size that renderSize lerps towards
  protected float actualSize;
  //Thickness of outline
  protected float outlineSize;
  //Colour of fill
  protected PVector fill;
  //Colours of outline
  protected PVector stroke;
  //If true, will arrange children as if it had 1 more than it actually does
  private boolean ignoreParent;
  //List of child nodes
  private ArrayList<Node> children;

  Node(PVector location, PVector renderLocation, float size, float actualSize, float outlineSize, float alignAngle, String text, PVector fill, PVector stroke, boolean ignoreParent, int childCount) {
    this.location = location.get();
    this.renderLocation = renderLocation.get();
    this.renderSize = size;
    this.actualSize = actualSize;
    this.outlineSize = outlineSize;
    this.alignAngle = alignAngle;
    this.text = text;
    this.fill = fill.get();
    this.stroke = stroke.get();
    this.ignoreParent = ignoreParent;
    this.children = new ArrayList<Node>(childCount);
    this.addChildren(childCount);
  }

  void addChildren(int... navtree) {
    //Varargs is equivalent to passing an array in a single argument,
    //but simply provides better readability.
    if (navtree.length>1) {
      //If there are layers left to go in the navtree, pass it onto the specified child node.
      if (navtree[0]-1<0) {
        //Sanity check for negative index
        throw new IllegalArgumentException(String.format("Recieved index of %s which is smaller than the minimum index of 1.", navtree[0]));
      }
      if (this.children.size()<=navtree[0]-1) {
        //Sanity check for too large index
        println(String.format("Requested to pass navtree \"%s\" to child number %s when number of children is %s.\nAdding (%s) additional children to compensate...", Arrays.toString(navtree), navtree[0], this.children.size(), navtree[0]-this.children.size()));
        this.addChildren(navtree[0]-this.children.size());
      }
      this.children.get(navtree[0]-1).addChildren(Arrays.copyOfRange(navtree, 1, navtree.length));
    } else {
      if (navtree[0]==0) {
        return;
      }
      //If there is only 1 entry left in the navtree, add that many children to this node
      //Also rearrange preexisting children to take account of new children

        if (navtree[0]<0) {
        throw new IllegalArgumentException(String.format("Attempted to add an illegal number (%s) of children.", navtree[0]));
      }
      //Determine how many children we will have afterwards
      int newSize = this.children.size()+navtree[0];
      this.children.ensureCapacity(newSize);
      //Add children until we reach the desired amount
      for (int i=this.children.size (); i<newSize; i++) {
        this.children.add(new NodeBuilder()
          .setRenderLocation(this.location())
          .setActualSize(this.actualSize()*CHILD_SIZE_SCALAR)
          .setSize(SIZE_CHANGE_AMT)
          .setIgnoreParent(false)
          .build()
          );
      }

      this.realignChildren();
    }
  }

  void realignChildren() {
    if (this.children.size() <= 0) return;
    PVector offset = PVector.fromAngle(radians(this.alignAngle));
    offset.setMag(this.actualSize()*(CHILD_SIZE_SCALAR/2+0.5)*CHILD_DIST_SCALAR);
    float angleIncrement = 360/(this.children().size()+((this.ignoreParent)?0:1));
    if (!this.ignoreParent) offset.rotate(radians(180+angleIncrement));
    for (Node n : this.children ()) {
      PVector position = PVector.add(this.location(), offset);
      n.setLocation(position);
      n.setAngle(degrees(offset.heading()));
      n.realignChildren();
      offset.rotate(radians(angleIncrement));
    }
  }

  float getSize() {
    return this.renderSize;
  }

  float actualSize() {
    return this.actualSize;
  }

  float getAngle() {
    return this.alignAngle;
  }

  PVector location() {
    return this.location.get();
  }

  PVector renderLocation() {
    return this.renderLocation.get();
  }

  String getText() {
    return this.text;
  }

  void setText(String text) {
    this.text = text;
  }

  void appendChar(char Char) {
    this.text += Char;
  }

  void appendText(String text) {
    this.text.concat(text);
  }

  void prependChar(char Char) {
    this.text = Char+this.text;
  }

  void prependText(String text) {
    this.text = text.concat(this.text);
  }

  void addSize(float amt) {
    this.actualSize += amt;
  }

  void reduceSize(float amt) {
    this.actualSize -= amt;
    if (this.actualSize < SIZE_CHANGE_AMT) this.actualSize = SIZE_CHANGE_AMT;
  }

  void setSize(float amt) {
    this.actualSize = amt;
  }

  void setRenderSize(float amt) {
    this.renderSize = amt;
  }

  void setAngle(float angle) {
    this.alignAngle = angle;
  }

  char popChar() {
    char result = this.text.charAt(this.text.length()-1);
    this.text = this.text.substring(0, this.text.length()-1);
    return result;
  }

  List<Node> children() {
    return this.children;
  }

  void setLocation(PVector target) {
    PVector offset = PVector.sub(target, this.location());
    this.location = target.get();
    for (Node n : this.children ()) {
      n.offsetLocation(offset);
    }
  }

  void offsetLocation(PVector offset) {
    this.location.add(offset.get());
    for (Node n : this.children ()) {
      n.offsetLocation(offset);
    }
  }

  void setRenderLocation(PVector target) {
    PVector offset = PVector.sub(target, this.renderLocation());
    this.renderLocation = target.get();
    for (Node n : this.children ()) {
      n.offsetRenderLocation(offset);
    }
  }

  void setRenderLocation(float amt, boolean axis) {
    PVector origin = this.renderLocation.get();
    if (axis) {
      this.renderLocation.x = amt;
    } else {
      this.renderLocation.y = amt;
    }
    PVector diff = PVector.sub(this.renderLocation, origin);
    for (Node n : this.children ()) {
      n.offsetRenderLocation(diff);
    }
  }

  void setLocation(float amt, boolean axis) {
    PVector origin = this.location();
    if (axis) {
      this.location.x = amt;
    } else {
      this.location.y = amt;
    }
    PVector diff = PVector.sub(this.location(), origin);
    for (Node n : this.children ()) {
      n.offsetLocation(diff);
    }
  }

  void offsetRenderLocation(PVector offset) {
    this.renderLocation.add(offset.get());
    for (Node n : this.children ()) {
      n.offsetRenderLocation(offset);
    }
  }

  void setFill(PVector fill) {
    this.fill = fill.get();
  }

  void setFill(float fill) {
    this.fill = new PVector(fill, fill, fill);
  }

  void constrainToBounds() {
    float radius = this.actualSize()/2;
    if (this.location().x - radius - this.outlineSize < POSITIVE_INDENT.x) {
      this.setLocation(POSITIVE_INDENT.x + radius + this.outlineSize, true);
    }

    if (this.location().y - radius - this.outlineSize < POSITIVE_INDENT.y) {
      this.setLocation(POSITIVE_INDENT.y + radius + this.outlineSize, false);
    }

    if (this.location().x + radius + this.outlineSize > width - NEGATIVE_INDENT.x) {
      this.setLocation(width - NEGATIVE_INDENT.x - radius - this.outlineSize, true);
    }

    if (this.location().y + radius + this.outlineSize > height - NEGATIVE_INDENT.y) {
      this.setLocation(height - NEGATIVE_INDENT.y - radius - this.outlineSize, false);
    }
  }

  boolean speculativeCollide(PVector point) {
    //Returns whether or not a given point is touching this node
    return PVector.dist(point, this.location())<this.actualSize/2;
  }

  boolean deepCollide(PVector point) {
    //Recursively polls collision for a given point on every child node
    boolean hasCollided = this.speculativeCollide(point);
    for (Node n : this.children) {
      if (hasCollided) break;
      hasCollided = n.deepCollide(point);
    }
    return hasCollided;
  }

  Node investigativeCollide(PVector point) {
    //Recursively polls collision for a given point on every child node
    //Returns a reference to the LAST node that was collided
    //Uses breadth-first search

    Node lastCollided = null;

    Queue<Node> list = new LinkedList<Node>();
    list.add(this);

    while (!list.isEmpty ()) {
      Node next = list.poll();
      if (next!=null) {
        if (next.speculativeCollide(point)) lastCollided = next;
        list.addAll(next.children());
      }
    }

    return lastCollided;
  }

  void shallowRender() {
    //Function to actually render this node
    fill(this.fill.x, this.fill.y, this.fill.z);
    stroke(this.stroke.x, this.stroke.y, this.stroke.z);
    strokeWeight(this.outlineSize);
    ellipse(this.renderLocation().x, this.renderLocation().y, this.renderSize);
    textAlign(CENTER, CENTER);
    fill(this.stroke.x, this.stroke.y, this.stroke.z);
    noStroke();

    float boxSize = sqrt(sq(this.renderSize)/2);

    textSize(getBestFontSize(boxSize, boxSize, this.text));
    text(this.text, this.renderLocation().x, this.renderLocation().y, boxSize, boxSize);
  }

  void deepRender() {
    //Recursively renders ALL child nodes
    //Uses breadth-first search, so that 'deeper' nodes are rendered after, and thus over, 'shallower' nodes.
    Queue<Node> list = new LinkedList<Node>();
    list.add(this);

    while (!list.isEmpty ()) {
      Node next = list.poll();
      if (next!=null) {
        next.shallowRender();
        list.addAll(next.children());
      }
    }
  }

  void updateLerps() {
    //Apply one iteration to values associated with linear interpolation
    if (PVector.dist(this.location(), this.renderLocation())>GENERAL_LERP_AMT) {
      PVector dir = PVector.sub(this.location(), this.renderLocation());
      dir.mult(GENERAL_LERP_AMT);
      this.offsetRenderLocation(dir);
    }

    float diff = this.actualSize() - this.getSize();
    if (abs(diff)>GENERAL_LERP_AMT) {
      diff *= GENERAL_LERP_AMT;
      this.renderSize += diff;
    }
  }

  void deepUpdateLerps() {
    Queue<Node> list = new LinkedList<Node>();
    list.add(this);

    while (!list.isEmpty ()) {
      Node next = list.poll();
      if (next!=null) {
        next.updateLerps();
        list.addAll(next.children());
      }
    }
  }

  void renderConnections() {
    stroke(this.stroke.x, this.stroke.y, this.stroke.z);
    strokeWeight(this.outlineSize);
    for (Node n : this.children ()) {
      line(this.renderLocation().x, this.renderLocation().y, n.renderLocation().x, n.renderLocation().y);
    }
  }

  void deepRenderConnections() {
    Queue<Node> list = new LinkedList<Node>();
    list.add(this);

    while (!list.isEmpty ()) {
      Node next = list.poll();
      if (next!=null) {
        next.renderConnections();
        list.addAll(next.children());
      }
    }
  }

  boolean deleteChild(Node target) {
    if (this.children.contains(target)) {
      target.deepDeleteChildren();
    }
    return this.children.remove(target);
  }

  boolean deleteFromIndex(int index) {
    if (index >= this.children.size() || index < 0) return false;
    this.children.get(index).deepDeleteChildren();
    this.children.remove(index);
    return true;
  }

  void deepDeleteChild(Node target) {

    Queue<Node> list = new LinkedList<Node>();
    list.add(this);

    while (!list.isEmpty ()) {
      Node next = list.poll();
      if (next!=null) {
        if (next.deleteChild(target)) return;
        list.addAll(next.children());
      }
    }
  }

  void deepDeleteChildren() {
    Stack<Node> list = new Stack<Node>();
    list.push(this);

    while (!list.empty ()) {
      Node next = list.peek();
      if (next!=null) {
        if (next.children().size()>0) {
          list.addAll(next.children());
          next.children.clear();
        } else {
          addToRemove(next);
          next.setSize(0);
          list.pop();
        }
      }
    }
  }
}

