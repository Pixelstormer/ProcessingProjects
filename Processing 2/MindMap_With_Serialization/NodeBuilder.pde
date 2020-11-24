class NodeBuilder<T extends NodeBuilder<T>> {
  protected PVector    location       = new PVector(0, 0);
  protected PVector    renderLocation = new PVector(0, 0);
  protected String     text           = "";
  protected float      alignAngle     = 0;
  protected float      size           = 80;
  protected float      actualSize     = 80;
  protected float      outlineSize    = 4;
  protected PVector    fill           = new PVector(40, 40, 40);
  protected PVector    stroke         = new PVector(255, 255, 255);
  protected boolean    ignoreParent   = false;
  protected int        childCount     = 0;
  protected List<Node> children       = new ArrayList<Node>(childCount);

  T setLocation(PVector set) {
    this.location = set.get();
    return (T) this;
  }

  T setRenderLocation(PVector set) {
    this.renderLocation = set.get();
    return (T) this;
  }

  T setText(String text) {
    this.text = text;
    return (T) this;
  }

  T setAngle(float angle) {
    this.alignAngle = angle;
    return (T) this;
  }

  T setSize(float size) {
    this.size = size;
    return (T) this;
  }

  T setActualSize(float size) {
    this.actualSize = size;
    return (T) this;
  }

  T setOutline(float outline) {
    this.outlineSize = outline;
    return (T) this;
  }

  T setFill(PVector fill) {
    this.fill = fill.get();
    return (T) this;
  }

  T setStroke(PVector stroke) {
    this.stroke = stroke.get();
    return (T) this;
  }

  T setIgnoreParent(boolean ignore) {
    this.ignoreParent = ignore;
    return (T) this;
  }

  T setChildCount(int count) {
    this.childCount = count;
    return (T) this;
  }

  Node build() {
    return new Node(this.location, this.renderLocation, this.size, this.actualSize, this.outlineSize, this.alignAngle, this.text, this.fill, this.stroke, this.ignoreParent, this.childCount);
  }
}

