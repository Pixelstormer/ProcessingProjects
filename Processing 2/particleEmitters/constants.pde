static final PVector GRAVITY = new PVector(0,1);

static final PVector[] SHAPE_SQUARE = new PVector[]{
  new PVector(1,1),
  new PVector(1,-1),
  new PVector(-1,-1),
  new PVector(-1,1)
};

static final PVector[] SHAPE_TRIANGLE = new PVector[]{
  new PVector(0,-1),
  new PVector(1,1),
  new PVector(-1,1)
};

static final PVector[] SHAPE_HORIZONTAL_LINE = new PVector[]{
  new PVector(-1,0),
  new PVector(1,0)
};

static final PVector[] SHAPE_VERTICAL_LINE = new PVector[]{
  new PVector(0,-1),
  new PVector(0,1)
};

static final PVector[] SHAPE_DIAGONAL_DOWN = new PVector[]{
  new PVector(-1,-1),
  new PVector(1,1)
};

static final PVector[] SHAPE_DIAGONAL_UP = new PVector[]{
  new PVector(-1,1),
  new PVector(1,-1)
};
