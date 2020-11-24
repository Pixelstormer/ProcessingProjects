int[][] tiles;
int tileSize=20;
int gridWidth = 10;
int gridHeight = 22;

int blockIndex=floor(random(7));
int previewIndex=floor(random(7));

int gravityTimer;
int gravityInterval=1600;

int shiftingTimer;
int shiftingInterval=60;

int droppingTimer;
int droppingInterval=60;

int lockingTimer;
int lockingInterval=750;

int score=0;

int[][] preview;

boolean[] movePieceInputs = new boolean[3];

PVector gridCenter;

Tetromino activePiece;
Tetromino previewPiece;
Tetromino heldPiece;

void setup() {
  size(860, 520);
  frame.setResizable(true);
  stroke(48);
  background(0);
  colorMode(HSB, 360);

  tiles = new int[gridWidth][gridHeight];
  preview=new int[4][4];

  updateColours();
  updateColours();

  gridCenter = new PVector(floor(gridWidth/2)-1, 1);

  previewPiece = spawnTetromino(getRotationFromIndex(getPieceFromIndex(previewIndex), 0), new PVector(1, 2), 0);
  activePiece = spawnTetromino(getRotationFromIndex(getPieceFromIndex(blockIndex), 0), gridCenter, 0);

  for (int x=0; x<gridWidth; x++) {
    for (int y=0; y<gridHeight; y++) {
      tiles[x][y]=0;
    }
  }

  resetPreview();
  gravityTimer=millis();
}

void draw() {
  background(0);
  if (millis()-shiftingTimer>shiftingInterval) {
    if (movePieceInputs[0]) {
      activePiece.move(new PVector(-1, 0), false);
      shiftingTimer=millis();
    }
    if (movePieceInputs[1]) {
      activePiece.move(new PVector(1, 0), false);
      shiftingTimer=millis();
    }
  }

  if (!activePiece.grounded) {
    lockingTimer=millis();
  }

  if (activePiece.grounded) {
    if (millis()-lockingTimer>lockingInterval) {
      activePiece.lockPiece();
    }
  } else if (movePieceInputs[2]) {
    if (millis()-droppingTimer>droppingInterval) {
      activePiece.move(new PVector(0, 1), false);
      droppingTimer=millis();
    }
  } else if (millis()-gravityTimer>gravityInterval) {
    activePiece.move(new PVector(0, 1), true);
    gravityTimer=millis();
    activePiece.checkIfGrounded();
  }

  render();
  drawPreview();
  fill(255);
  text(score, width/1.2, height/1.4);
}

void render() {
  for (PVector p : activePiece.minos) {
    tiles[int(p.x)][int(p.y)] = getHueFromIndex(blockIndex);
  }
  for (int x = 0; x < gridWidth; x++) {
    for (int y = 2; y < gridHeight; y++) {
      if (tiles[x][y]==0) {
        fill(0);
      } else {
        fill(tiles[x][y], 360, 360);
      }

      rect(width/2 - (gridWidth/2 * tileSize) + (tileSize * x), height/2 - (gridHeight/2 * tileSize) + (tileSize * y), tileSize, tileSize);
    }
  }
}

void drawPreview() {
  for (PVector p : previewPiece.minos) {
    try {
      preview[int(p.x)][int(p.y)]=getHueFromIndex(previewIndex);
    }
    catch(ArrayIndexOutOfBoundsException e) {
      println(previewIndex);
    }
  }
  for (int x=0; x<4; x++) {
    for (int y=0; y<4; y++) {
      if (preview[x][y]==0) {
        fill(0);
      } else {
        fill(preview[x][y], 360, 360);
      }
      rect(x*tileSize+width/1.2, y*tileSize+(height-height/1.2), tileSize, tileSize);
    }
  }
}

void resetPreview() {
  for (int x=0; x<4; x++) {
    for (int y=0; y<4; y++) {
      preview[x][y]=0;
    }
  }
}

void clearLines() {
  IntList toClear = new IntList();
  for (int y=0; y<gridHeight; y++) {
    boolean full=true;
    for (int x=0; x<gridWidth; x++) {
      if (tiles[x][y]==0) {
        full=false;
      }
    }
    if (full) {
      toClear.append(y);
    }
  }

  for (int y : toClear) {
    score++;
    gravityInterval-=35;
    droppingInterval-=1;
    for (int x=0; x<gridWidth; x++) {
      tiles[x][y]=0;
      for (int u=y-1; u>=0; u--) {
        tiles[x][u+1]=tiles[x][u];
        tiles[x][u]=0;
      }
    }
  }
}

Tetromino spawnTetromino(PVector[] offset, PVector origin, int r) {
  PVector[] minos = new PVector[4];
  for (int i=0; i<4; i++) {
    minos[i] = PVector.add(origin, offset[i]);
  }
  return new Tetromino(minos, r);
}

void updateColours() {
  blockIndex = previewIndex;
  previewIndex = floor(random(7));
  previewPiece = spawnTetromino(getRotationFromIndex(getPieceFromIndex(previewIndex), 0), new PVector(2, 2), 0);
  resetPreview();
}

PVector[][] getPieceFromIndex(int i) {
  PVector[][] piece = new PVector[4][4];
  for (int r=0; r<4; r++) {
    for (int m=0; m<4; m++) {
      piece[r][m] = Rotations[i][r][m];
    }
  }
  return piece;
}

PVector[] getRotationFromIndex(PVector[][] piece, int i) {
  PVector[] state = new PVector[4];
  for (int m=0; m<4; m++) {
    state[m]=piece[i][m];
  }
  return state;
}

int getCenterPointIndex() {
  switch(blockIndex) {
  case 0:
    return 0;
  case 1:
    return 0;
  case 2:
    return 1;
  case 3:
    return 2;
  case 4:
    return 1;
  case 5:
    return 1;
  case 6:
    return 1;
  default:
    return 0;
  }
}

int getHueFromIndex(int i) {
  switch(i) {
  case 0:
    return 62;
  case 1:
    return 295;
  case 2:
    return 40;
  case 3:
    return 240;
  case 4:
    return 120;
  case 5:
    return 360;
  case 6:
    return 185;
  default:
    return 62;
  }
}

void keyPressed() {
  switch(key) {
  case 'a':
  case 'A':
    movePieceInputs[0] = true;
    break;
  case 'd':
  case 'D':
    movePieceInputs[1] = true;
    break;
  case 's':
  case 'S':
    movePieceInputs[2] = true;
    break;
  }
}

void keyReleased() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case LEFT:
      activePiece.Rotate(true);
      break;
    case RIGHT:
      activePiece.Rotate(false);
      break;
    }
    break;
  case ' ':
    activePiece.castToFloor();
    activePiece.lockPiece();
    break;
  case 'a':
  case 'A':
    movePieceInputs[0] = false;
    break;
  case 'd':
  case 'D':
    movePieceInputs[1] = false;
    break;
  case 's':
  case 'S':
    movePieceInputs[2] = false;
    break;
  }
}

