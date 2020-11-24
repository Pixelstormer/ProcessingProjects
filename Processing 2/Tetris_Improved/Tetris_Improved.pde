PImage CyanMino, BlueMino, OrangeMino, YellowMino, GreenMino, PurpleMino, RedMino;
//I-Cyan, J-Blue, L-Orange, O-yellow, S-Green, T-Purple, Z-Red
PImage[] MinoImages;

Mino[][] grid; //2D array to store minos present on the field
int gridWidth, gridHeight; //Width and height of playing field
int margin; //Extra tiles above field to spawn tetrominos in
PVector originPoint; //Tetromino spawnpoint
PVector holdPoint; //Position of hold piece to be rendered
PVector queueOrigin; //Initial position to render queue pieces from
int tileSize=20; //Visual size of grid and minos
int queueSize=7; //Size of preview queue limited from 0-7

Randomizer pieceGenerator; //Determines the queue with a shuffled bag
Piece_Generator minoGenerator; //Tool to construct tetromino and mino objects
TetrominoHandler pieceHandler; //Handles the active piece, eg. harddrop logic, mino collision etc.
TetrominoHandler ghostPiece; //Handler for ghost piece
TetrominoHandler heldPiece; //Handler for hold slot

boolean swapped=false;

int gravityInterval=2000; //Gravity moves piece down every this many milliseconds
int gravityTimer;
int gravityScalar = 15;
int gravityModulo = 1;

int shiftingInterval=80; //DAS moves piece horizontally every this many milliseconds
int shiftingTimer;

int softDropInterval=80;//Soft drop moves piece down every this many milliseconds
int softDropTimer;
int softDropScalar = 1;
int softDropModulo = 4;

int lockDelay=100; //Piece has this many frames of lock delay
int lockDelayTimer=lockDelay;
int lockDelayScalar = 1;
int lockDelayModulo = 4;

int linesCleared = 0;

boolean[] heldInputs=new boolean[3];
//heldInputs[0]=move piece left
//heldInputs[1]=move piece right
//heldInputs[2]=soft drop

void setup() {
  size(840, 560);
  frame.setResizable(true);
  noSmooth();

  //All the mino sprites
  CyanMino=loadImage("Cyan-Mino.png");
  BlueMino=loadImage("Blue-Mino.png");
  OrangeMino=loadImage("Orange-Mino.png");
  YellowMino=loadImage("Yellow-Mino.png");
  GreenMino=loadImage("Green-Mino.png");
  PurpleMino=loadImage("Purple-Mino.png");
  RedMino=loadImage("Red-Mino.png");

  //Array to store the mino sprites in
  MinoImages=new PImage[]{
    YellowMino, 
    PurpleMino, 
    OrangeMino, 
    BlueMino, 
    GreenMino, 
    RedMino, 
    CyanMino
  };

  //Tilesize can't be 0 or negative
  if (tileSize<=0) {
    println("Tilesize must be greater than 0 : defaulting to 20.");
    tileSize=20;
  }
  
  if(constrain(queueSize,0,7)!=queueSize){
    println("queueSize must be between 0 and 7 : clamping to closest possible value.");
  }
  queueSize = constrain(queueSize,0,7);

  //Initializing variables
  gridWidth=10;
  gridHeight=20;
  margin=2;
  gridHeight+=margin;
  grid=new Mino[gridWidth][gridHeight];
  originPoint=new PVector(floor(gridWidth/2), 1);
  holdPoint=convVectorToGridRef(new PVector((width/2-tileSize*gridWidth/2)/2,height/4));
  queueOrigin=convVectorToGridRef(new PVector((width/2+tileSize*gridWidth/2)*1.2,height/6));
  
  pieceGenerator=new Randomizer();
  minoGenerator=new Piece_Generator();
  int index=pieceGenerator.cycleNextPiece();
  pieceHandler=new TetrominoHandler(minoGenerator.generateTetrominoFromIndex(index,0,originPoint));
  heldPiece=new TetrominoHandler(null);
  ghostPiece=new TetrominoHandler(minoGenerator.generateTetrominoFromIndex(0,0,originPoint));
  for(int i=0;i<4;i++){
    ghostPiece.getTetromino().Minos[i].move(pieceHandler.getTetromino().Minos[i].getPos());
  }
  updateGhostPiece();
  clearGrid();
}

void draw() {
  //long frameStartTime = System.nanoTime();
  background(0);

  if (millis()-gravityTimer>gravityInterval) {
    if (!heldInputs[2]) {
      offsetActivePiece(new PVector(0, 1));
    }
    gravityTimer=millis();
  }

  if (millis()-shiftingTimer>shiftingInterval) {
    if (heldInputs[0]) {
      offsetActivePiece(new PVector(-1, 0));
      shiftingTimer=millis();
    }
    if (heldInputs[1]) {
      offsetActivePiece(new PVector(1, 0));
      shiftingTimer=millis();
    }
  }

  if (millis()-softDropTimer>softDropInterval && heldInputs[2]) {
    offsetActivePiece(new PVector(0, 1));
    softDropTimer=millis();
  }

  if (pieceHandler.isTetrominoGrounded) {
    lockDelayTimer--;
  }
  if (lockDelayTimer<=0) {
    pieceHandler.lockTetromino();
    lockDelayTimer=lockDelay;
  }

  renderGrid();
  renderHold();
  renderQueue();
  renderMinos();
  tint(255,127.5);
  ghostPiece.renderTetromino();
  noTint();
  pieceHandler.renderTetromino();
  renderCover();
  long frameEndTime = System.nanoTime();
  //println("Frame took " + ((frameEndTime - frameStartTime)/1000000) + " milliseconds.");
}

void renderGrid() { //Purely visual grid to represent playing field
  noFill();
  stroke(45);
  for (int x=0; x<gridWidth; x++) {
    for (int y=margin; y<gridHeight; y++) {
      rect(convIntToScreenCoord(x, true), convIntToScreenCoord(y, false), tileSize, tileSize);
    }
  }
}

void renderHold(){
  try{
    heldPiece.renderTetromino();
  }
  catch(NullPointerException e){
  }
}

void renderQueue(){
  int[] primaryPieces = pieceGenerator.getPrimaryArray();
  int[] secondaryPieces = pieceGenerator.getSecondaryArray();
  int queueStartIndex = pieceGenerator.getBagIndex();
  int whichPieceIndex = queueStartIndex;
  boolean isUsingPrimary = pieceGenerator.getUsingPrimary();
  boolean whichPieceQueue = isUsingPrimary;
  PVector queuePos = queueOrigin.get();
  for(int i=0;i<queueSize;i++){
    whichPieceIndex = queueStartIndex+i;
    if(whichPieceIndex>=7){
      whichPieceIndex -= 7;
      whichPieceQueue = !isUsingPrimary;
    }
    TetrominoHandler piece;
    if(whichPieceQueue){
      piece = new TetrominoHandler(minoGenerator.generateTetrominoFromIndex(primaryPieces[whichPieceIndex],0,queuePos));
    }
    else{
      piece = new TetrominoHandler(minoGenerator.generateTetrominoFromIndex(secondaryPieces[whichPieceIndex],0,queuePos));
    }
    piece.renderTetromino();
    queuePos.y += 3;
  }
}

void renderMinos() { //Function that actually renders the minos present on the grid
  for (int x=0;x<gridWidth; x++) {
    for (int y=margin; y<gridHeight; y++) {
      try {
        grid[x][y].render();
      }
      catch(NullPointerException e) {
      }
    }
  }
}

void renderCover() {
  noStroke();
  fill(0);
  rect(convIntToScreenCoord(0, true), convIntToScreenCoord(0, false), gridWidth*tileSize, margin*tileSize);
}

void clearGrid() {
  for (int x=0; x<gridWidth; x++) {
    for (int y=0; y<gridHeight; y++) {
      grid[x][y]=null;
    }
  }
}

void clearFilledLines() {
  for (int y=0; y<gridHeight; y++) {
    boolean isFilled=true;
    for (int x=0; x<gridWidth; x++) {
      isFilled = isFilled && grid[x][y]!=null;
    }
    if (isFilled) {
      linesCleared++;
      
      if(linesCleared % gravityModulo == 0){
        gravityInterval -= gravityScalar;
        if(gravityInterval < 0)
          gravityInterval = 0;
      }
      
      if(linesCleared % softDropModulo == 0){
        softDropInterval -= softDropScalar;
        if(softDropInterval < 0)
          softDropInterval = 0;
      }
      
      if(linesCleared % lockDelayModulo == 0){
        lockDelay -= lockDelayScalar;
        if(lockDelay < 0)
          lockDelay = 0;
      }
      println(String.format("Gravity scaled to %sms. Soft drop scaled to %sms. Lock delay scaled to %sms.", gravityInterval, softDropInterval, lockDelay));
      for (int x=0; x<gridWidth; x++) {
        grid[x][y]=null;
        for (int Y=y; Y>0; Y--) {
          grid[x][Y]=grid[x][Y-1];
          try {
            grid[x][Y].offset(new PVector(0, 1));
          }
          catch(NullPointerException e) {}
          grid[x][Y-1]=null;
        }
      }
    }
  }
}

void addMinoToGrid(Mino mino, PVector ref) {
  try {
    grid[int(ref.x)][int(ref.y)]=new Mino(mino.getPos(), mino.getSprite(), mino.getSize());
  }
  catch(ArrayIndexOutOfBoundsException e) {
    println("Attempted to place mino OOB");
  }
}

void offsetActivePiece(PVector offset){
  pieceHandler.offsetTetromino(offset);
  updateGhostPiece();
}

void rotateActivePiece(int rotation){
  int oldRotation=pieceHandler.rotationIndex;
  pieceHandler.changeRotationIndex(rotation);
  if(!pieceHandler.updateTetrominoRotation()){
    pieceHandler.setRotationIndex(oldRotation);
  }
  updateGhostPiece();
}

void updateGhostPiece(){
  for(int i=0;i<4;i++){
    ghostPiece.getTetromino().Minos[i].move(pieceHandler.getTetromino().Minos[i].getPos());
    ghostPiece.getTetromino().Minos[i].updateSprite(pieceHandler.getTetromino().Minos[i].getSprite());
  }
  ghostPiece.isTetrominoGrounded=false;
  while(!ghostPiece.isTetrominoGrounded){
    ghostPiece.checkIfGrounded();
    ghostPiece.offsetTetromino(new PVector(0,1));
  }
}

void swapToNextPiece() {
  pieceHandler.changeTetromino(minoGenerator.generateTetrominoFromIndex(pieceGenerator.cycleNextPiece(),0,originPoint));
  gravityTimer=millis();
  offsetActivePiece(new PVector(0,0));
  pieceHandler.setRotationIndex(0);
  pieceHandler.checkIfGrounded();
  swapped=false;
  updateGhostPiece();
}

void swapHoldSlotPiece(){
  if(!swapped){
    if(heldPiece.tetromino==null){
      heldPiece.changeTetromino(minoGenerator.generateTetrominoFromIndex(pieceHandler.tetromino.index,0,holdPoint));
      swapToNextPiece();
    }
    else{
      Tetromino toSwap=heldPiece.tetromino;
      heldPiece.changeTetromino(minoGenerator.generateTetrominoFromIndex(pieceHandler.tetromino.index,0,holdPoint));
      pieceHandler.changeTetromino(minoGenerator.generateTetrominoFromIndex(toSwap.index,0,originPoint));
    }
    swapped=true;
    pieceHandler.setRotationIndex(0);
    updateGhostPiece();
  }
}

int getCenterPointFromIndex(int index){
  switch(index) {
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

float convIntToScreenCoord(int gridRef, boolean axis) {
  if (axis) { //X-axis
    return 0.5*(width - gridWidth*tileSize + 2*tileSize*gridRef);
  }
  //Y-axis
  return 0.5*(height - gridHeight*tileSize + 2*tileSize*gridRef);
}

PVector convVectorToScreenCoord(PVector gridRef) {
  PVector result=new PVector(
  0.5*(width - gridWidth*tileSize + 2*tileSize*gridRef.x), 
  0.5*(height - gridHeight*tileSize + 2*tileSize*gridRef.y)
    );
  return result;
}

int convFloatToGridRef(float coord, boolean axis) {
  if (axis) { //X-axis
    return int((2*coord-width+gridWidth*tileSize)/(2*tileSize));
  }
  //Y-axis
  return int((2*coord-height+gridHeight*tileSize)/(2*tileSize));
}

PVector convVectorToGridRef(PVector coord) {
  PVector result = new PVector(
  (2*coord.x-width+gridWidth*tileSize)/(2*tileSize), 
  (2*coord.y-height+gridHeight*tileSize)/(2*tileSize)
    );
  return result;
}

void dumpStack() {
  Thread.dumpStack();
}

void keyPressed() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:    //Hard Drop
      
      break;
    case DOWN:  //Soft Drop
      heldInputs[2]=true;
      break;
    case LEFT:  //Anti-clockwise Rotation
    
      break;
    case RIGHT: //Clockwise Rotation
    
      break;
    case ALT:
    case CONTROL:
    case SHIFT: //Hold

      break;
    }
    break;
  case 'a':
  case 'A': //Move Left
    heldInputs[0]=true;
    break;
  case 'd':
  case 'D': //Move right
    heldInputs[1]=true;
    break;
  case 's':
  case 'S': //Soft Drop
    heldInputs[2]=true;
    break;
  case 'w':
  case 'W':
  case ' ': //Hard Drop
    
    break;
  }
}

void keyReleased() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:    //Hard Drop
      pieceHandler.hardDropTetromino();
      break;
    case DOWN:  //Soft Drop
      heldInputs[2]=false;
      break;
    case LEFT:  //Anti-clockwise Rotation
      rotateActivePiece(-1);
      break;
    case RIGHT: //Clockwise Rotation
      rotateActivePiece(1);
      break;
    case ALT:
    case CONTROL:
    case SHIFT: //Hold
      swapHoldSlotPiece();
      break;
    }
  case 'a':
  case 'A': //Move Left
    heldInputs[0]=false;
    break;
  case 'd':
  case 'D': //Move right
    heldInputs[1]=false;
    break;
  case 's':
  case 'S': //Soft Drop
    heldInputs[2]=false;
    break;
  case 'w':
  case 'W':
  case ' ': //Hard Drop
    pieceHandler.hardDropTetromino();
    break;
  }
}

