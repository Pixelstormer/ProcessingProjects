int cellSize=20;
tile[][] cells;
tile[][] cellsBuffer;
int guiMargin=120;
boolean overCell;

color empty=#000000; //"EMPTY"
color ground=#18B904; //"GROUND" || "USEDGROUND"
color enemy=#E01009; //"ENEMY"
color water=#0095F0; //"WATER"
String paintMode;

ArrayList<button> buttons=new ArrayList();

int lives=20;

int interval = 1000;
int lastRecordedTime = 0;

boolean paintSwitch=true;

void setup() {
  size(860, 520);
  frame.setResizable(true);
  stroke(48);

  cells=new tile[(width-guiMargin)/cellSize][height/cellSize];
  cellsBuffer=new tile[(width-guiMargin)/cellSize][height/cellSize];
  for (int x=0; x< (width-guiMargin)/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cells[x][y]=new tile("EMPTY", x, y);
    }
  }

  buttons.add(new button(37.5, 60, "GROUND"));
  buttons.add(new button(37.5, 120, "ENEMY"));
  buttons.add(new button(37.5, 180, "WATER"));
  paintMode="GROUND";
}

void draw() {
  background(#0561A5);

  if (millis()-lastRecordedTime>interval) {
    iteration();
    lastRecordedTime = millis();
  }

  for (button b : buttons) {
    b.render();
  }

  drawCells();
}

void drawCells() {
  for (int x=0; x< (width-guiMargin)/cellSize; x++) { //Iterating through all the cells
    for (int y=0; y<height/cellSize; y++) {
      fill(switchFill(cells[x][y].identifier));
      rect(x*cellSize+guiMargin, y*cellSize, cellSize, cellSize); //Draw cells
    }
  }
}

void iteration() {
  cellsBuffer=cells;

  for (int x=0; x< (width-guiMargin)/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cells[x][y].moved=false;
    }
  }

  for (int x=0; x< (width-guiMargin)/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if (cells[x][y].identifier=="ENEMY") {
        for (int xx=x-1; xx<=x+1; xx++) {
          if (cells[xx][y].identifier=="GROUND"
            &&!(cells[x][y].moved)) {

            cells[x][y].move(xx, y);
            break;
          }
          for (int yy=y-1; yy<=y+1; yy++) {
            if (cells[x][yy].identifier=="GROUND"
              &&!(cells[x][y].moved)) {

              cells[x][y].move(x, yy);
              break;
            }
          }
        }
      }
    }
  }
  
  if(paintSwitch){
    for (int x=0; x< (width-guiMargin)/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        if(cells[x][y].identifier=="USEDGROUND"){
          cells[x][y].identifier="GROUND";
        }
      }
    }
  }
  paintSwitch=!(paintSwitch);
}
  /*
void iteration(){
   for (int x=0; x< (width-guiMargin)/cellSize; x++) {
   for (int y=0; y<height/cellSize; y++) {
   cellsBuffer[x][y] = cells[x][y];
   }
   }
   
   for (int x=0; x< (width-guiMargin)/cellSize; x++) {
   for (int y=0; y<height/cellSize; y++) {
   // And visit all the neighbours of each cell
   for (int xx=x-1; xx<=x+1;xx++) {
   for (int yy=y-1; yy<=y+1;yy++) {  
   if (((xx>=0)&&(xx<(width-guiMargin)/cellSize))&&((yy>=0)&&(yy<height/cellSize))) { // Make sure you are not out of bounds
   if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
   if (cellsBuffer[xx][yy]==1){
   //**Do stuff**
   }
   } // End of if
   } // End of if
   } // End of yy loop
   } //End of xx loop
   // We've checked the neigbours: apply rules!
   //**Do more stuff**
   } // End of y loop
   } // End of x loop
   }
   */

  color switchFill(String code) {
    if (code=="EMPTY") {
      return empty;
    } else if (code=="GROUND"||code=="USEDGROUND") {
      return ground;
    } else if (code=="ENEMY") {
      return enemy;
    } else if (code=="WATER") {
      return water;
    } else {
      return empty;
    }
  }

  boolean overRect(float x, float y, int width, int height) {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }

  boolean overCircle(int x, int y, int diameter) {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } else {
      return false;
    }
  }

  void mouseReleased() {
    try { //Attempts to access the cells[][] array with a dummy variable.
      //If it throws an error, the mouse therefore isn't over a cell.
      //So we can skip attempting to set the cell entirely.
      tile placeholder=cells[(mouseX-guiMargin)/cellSize][mouseY/cellSize];
      overCell=true;
    }
    catch(ArrayIndexOutOfBoundsException e) {
      overCell=false;
    }

    if (overCell) {
      switch(mouseButton) {
      case LEFT:
        cells[(mouseX-guiMargin)/cellSize][mouseY/cellSize].identifier=paintMode;
        break;
      case RIGHT:
        cells[(mouseX-guiMargin)/cellSize][mouseY/cellSize].identifier="EMPTY";
        break;
      }
    } else {
      for (button b : buttons) {
        if (b.pressed()) {
          b.pressEvent();
        }
      }
    }
  }

  void mouseDragged() {
    try { //Attempts to access the cells[][] array with a dummy variable.
      //If it throws an error, the mouse therefore isn't over a cell.
      //So we can skip attempting to set the cell entirely.
      tile placeholder=cells[(mouseX-guiMargin)/cellSize][mouseY/cellSize];
      overCell=true;
    }
    catch(ArrayIndexOutOfBoundsException e) {
      overCell=false;
    }

    if (overCell) {
      switch(mouseButton) {
      case LEFT:
        cells[(mouseX-guiMargin)/cellSize][mouseY/cellSize].identifier=paintMode;
        break;
      case RIGHT:
        cells[(mouseX-guiMargin)/cellSize][mouseY/cellSize].identifier="EMPTY";
        break;
      }
    }
  }

