class Goal implements GameObject {
  private PVector position;
  private float size;
  private int score;

  Goal(PVector position, float size) {
    this.position = position.get();
    this.size = size;
    score = 0;
    displayName = "GOAL";
  }

  PVector position() {
    return this.position.get();
  }

  float size() {
    return this.size;
  }

  int score() {
    return this.score;
  }
  
  void addScore(){
    this.score++;
  }
  
  void addScore(int amt){
    this.score += amt;
  }

  void iterate() {
    render();
  }

  private void render() {
    stroke(255);
    fill(160);
    strokeWeight(3);
    ellipse(this.position.x, this.position.y, this.size, this.size);
    fill(255);
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(this.size/2);
    text(score, position.x, position.y);
  }
}

