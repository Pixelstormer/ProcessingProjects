cell[][] Cells;

int horizontalCells = 8;
int verticalCells = 8;

float cellWidth = 45;
float cellHeight = 45;

//Equivalent to 'drag' for fluid flow
float globalViscocity = 1;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  Cells = new cell[horizontalCells][verticalCells];
  for(int x=0;x<horizontalCells;x++){
    for(int y=0;y<verticalCells;y++){
      Cells[x][y] = new cell(new PVector(width/2+(x-horizontalCells/2)*cellWidth,height/2+(y-verticalCells/2)*cellHeight),new PVector(cellWidth,cellHeight),random(1000),0.2,0.01,random(100)<50, 2, random(100)>50);
    }
  }
  
  rectMode(CENTER);
  textAlign(CENTER,CENTER);
  background(0);
}

void draw(){
  background(0);
  float totalFluid = 0;
  for(int y=0;y<verticalCells;y++){
    for(int x=0;x<horizontalCells;x++){
      float flow = Cells[x][y].flow();
      for(int Y=-1;Y<=1;Y++){
        for(int X=-1;X<=1;X++){
          if(!(x+X == x && y+Y == y) && x+X >= 0 && y+Y >= 0 && x+X < horizontalCells && y+Y < verticalCells){
            Cells[x+X][y+Y].Fill(flow);
            Cells[x][y].Fill(-flow);
          }
        }
      }
      Cells[x][y].drain();
      Cells[x][y].fillSelf();
      totalFluid+=Cells[x][y].getFluid();
      Cells[x][y].render();
    }
  }
  
  text(totalFluid,width/2,height-45);
}


