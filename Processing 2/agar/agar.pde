import java.util.List;

List<Food> food;
List<Cell> cells;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  food = new ArrayList<Food>();
  cells = new ArrayList<Cell>();
  populateFood(5);
  cells.add(new Cell(new PVector(width/2, height/2), 2, 0.25, 45, 20, food));
}

void populateFood(int amt){
  for(int i=0; i<amt; i++){
    food.add(new Food(new PVector(width/5, height/2), random(2, 10)));
  }
}

void draw(){
  background(0);
  
  for(Food f : food){
    f.render();
  }
  
  for(int i=0; i<cells.size(); i++){
    Cell c = cells.get(i);
    
    c.update(cells.subList(i, cells.size()));
    if(c.getFood() <= 1){
      cells.remove(c);
    }
    c.render();
  }
}

void removeFood(Food item){
  if(food.contains(item)){
    food.remove(item);
    food.add(new Food(new PVector(random(width), random(height)), random(2,10)));
  }
  for(Cell c : cells){
    if(c.getTarget() == item)
      c.setTarget(c.getTarget(food));
  }
}

