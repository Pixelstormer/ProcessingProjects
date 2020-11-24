class NodeBuilder<T extends NodeBuilder<T>> {
  protected PVector    location       = new PVector(0, 0);
  protected PVector    renderLocation = new PVector(0, 0);
  protected String     text           = "";
  protected float      alignAngle     = 0;
  protected float      size           = 0;
  protected float      actualSize     = DEFAULT_TOP_LEVEL_SIZE;
  protected float      outlineSize    = 4;
  protected Color      fill           = DEFAULT_NODE_COLOUR;
  protected Color      highlightFill  = DEFAULT_HIGHLIGHT_COLOUR;
  protected Color      stroke         = DEFAULT_OUTLINE_COLOUR;
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

  T setFill(Color fill) {
    this.fill = fill;
    return (T) this;
  }
  
  T setHighlight(Color fill){
    this.highlightFill = fill;
    return (T) this;
  }

  T setStroke(Color stroke) {
    this.stroke = stroke;
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
    return new Node(this.location, this.renderLocation, this.size, this.actualSize, this.outlineSize, this.alignAngle, this.text, this.fill, this.highlightFill, this.stroke, this.ignoreParent, this.childCount);
  }
}

