class Bee extends Entity {
  //Seeks flowers
  
  boolean seeking;
  
  Flower target;
  Hive home;

  Bee(PVector position, Hive home) {
    super(position);
    this.home = home;
    this.seeking = true;;
  }

  Bee(Tile origin, Hive home) {
    super(origin);
    this.home = home;
    this.seeking = true;
  }

  Flower locateTarget() {
    for (Entity e : entities) {
      if (e==this) continue;
      if (!(e instanceof Flower)) continue;
      return (Flower) e;
    }
    return null;
  }

  Hive locateHome() {
    if (this.home != null) return this.home;
    for (int x=0; x<X_SIZE; x++) {
      for (int y=0; y<Y_SIZE; y++) {
        if(!(tiles[x][y] instanceof Hive)) continue;
        return (Hive)tiles[x][y];
      }
    }
    return null;
  }

  void iterate() {
    if(this.seeking){
      Flower prospectiveTarget = this.locateTarget();
      if (prospectiveTarget == null && this.target == null) return;
      if (this.target == null) this.target = prospectiveTarget;
      if (frameCount % 2 == 0) this.moveTowards(this.target);
      if (PVector.dist(super.position,this.target.getPosition())<TILE_SIZE/2) this.seeking = false;
    }
    else{
      Hive prospectiveHome = this.locateHome();
      if (prospectiveHome == null && this.home == null) return;
      if (this.home == null) this.home = prospectiveHome;
      if (frameCount % 2 == 0) this.moveTowards(this.home);
      if (PVector.dist(super.position,this.home.getRenderPosition())<TILE_SIZE/2) this.seeking = true;
    }
  }

  void move(PVector movement) {
    super.position.add(movement);
  }

  void moveTowards(Entity entity) {
    PVector position = entity.getPosition();
    PVector movement = new PVector(0, 0);

    boolean moveHorizontally = random(1) > 0.5;
    if (moveHorizontally) {
      movement.x = 2.4 * Math.signum(position.x-super.position.x);
    } else {
      movement.y = 2.4 * Math.signum(position.y-super.position.y);
    }

    this.move(movement);
  }

  void moveTowards(Tile tile) {
    PVector position = tile.getRenderPosition();
    PVector movement = new PVector(0, 0);

    boolean moveHorizontally = random(1) > 0.5;
    if (moveHorizontally) {
      movement.x = 3 * Math.signum(position.x-super.position.x);
    } else {
      movement.y = 3 * Math.signum(position.y-super.position.y);
    }

    this.move(movement);
  }

  void render() {
    stroke(0);
    strokeWeight(2);
    fill(255, 255, 0);
    circle(super.position.x, super.position.y, TILE_SIZE);
  }
}