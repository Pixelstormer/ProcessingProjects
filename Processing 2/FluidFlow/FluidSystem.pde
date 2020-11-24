class FluidSystem{
  //Dedicated rendering system
  private final SystemCamera camera;
  //ArrayList of ArrayList to simulate 2-dimensions, similar to Object[][].
  private final ArrayList<ArrayList<FluidCell>> cellColumns;
  //Width of system in FluidCells
  private final int systemWidth;
  //Height of system in FluidCells
  private final int systemHeight;
  //Maximum value that a fluidcell can store at one time
  private final float maximumAmount;
  //Viscocity coefficient of fluidcells - larger value means slower flow
  //Weird bug at low values (<6) that causes rapid flashing
  private final float viscocity;
  
  FluidSystem(int width, int height, float maximumAmount, float viscocity, PVector origin, float scalar){
    systemWidth = width;
    systemHeight = height;
    this.maximumAmount = maximumAmount;
    this.viscocity = viscocity;
    cellColumns = new ArrayList<ArrayList<FluidCell>>(systemWidth);
    camera = new SystemCamera(this, origin, scalar);
    initialiseSystem();
  }
  
  FluidSystem(int width, int height, float maximumAmount, float viscocity, float x, float y, float scalar){
    this(width, height, maximumAmount, viscocity, new PVector(x, y), scalar);
  }
  
  private void initialiseSystem(){
    //More of a reset than an init
    cellColumns.clear();
    for(int x = 0; x < systemWidth; x++){
      ArrayList<FluidCell> column = new ArrayList<FluidCell>(systemHeight);
      cellColumns.add(column);
      for(int y = 0; y < systemHeight; y++){
        FluidCell cell = new FluidCell(maximumAmount);
        column.add(cell);
      }
    }
  }
  
  FluidCell getCell(int x, int y){
    if(x<0 || x>=systemWidth || Y<0 || Y>=systemHeight)
      throw new IllegalArgumentException(String.format("Attempted to access a fluidcell that does not exist. (Given coordinates (%s, %s) are out of bounds.)", x, y));
    return cellColumns.get(x).get(y);
  }
  
  int getWidth(){
    return systemWidth;
  }
  
  int getHeight(){
    return systemHeight;
  }
  
  SystemCamera getCamera(){
    return camera;
  }
  
  void addFluid(int x, int y, float amount){
    if(x<0 || x>=systemWidth || Y<0 || Y>=systemHeight)
      throw new IllegalArgumentException(String.format("Attempted to modify a fluidcell that does not exist. (Given coordinates (%s, %s) are out of bounds.)", x, y));
    cellColumns.get(x).get(y).generateFluid(amount);
  }
  
  void removeFluid(int x, int y, float amount){
    addFluid(x, y, -amount);
  }
  
  ArrayList<ArrayList<FluidCell>> getNextIteration(){
    //Create a copy of the current system state to operate on
    ArrayList<ArrayList<FluidCell>> nextIteration = new ArrayList<ArrayList<FluidCell>>(systemWidth);
    for(int x = 0; x < systemWidth; x++){
      ArrayList<FluidCell> column = new ArrayList<FluidCell>(systemHeight);
      nextIteration.add(column);
      for(int y = 0; y < systemHeight; y++){
        //Rather than creating the copy, operating on it, then reapplying it,
        //we do the copying and operating in one go, so we only have to iterate
        //over the system twice rather than three times.
        FluidCell newCell = new FluidCell(maximumAmount, cellColumns.get(x).get(y).getAmount());
        
        //Iterate through all of our neighbours and accumulate the total difference in value we will have
        float netDifference = 0;
        for(int nx = x-1; nx <= x+1; nx++){
          for(int ny = y-1; ny <= y+1; ny++){
            if(nx >=0                  //Out
            && nx < systemWidth        //Of
            && ny >= 0                 //Bounds
            && ny < systemHeight       //Coordinates
            && !(nx == x && ny == y)){ //+Don't compare with yourself
              FluidCell neighbour = cellColumns.get(nx).get(ny);
              netDifference += (neighbour.getAmount()-newCell.getAmount())/viscocity;
            }
          }
        }
        //Apply the accumulated difference to the cell and add it to the system copy
        newCell.generateFluid(netDifference);
        column.add(newCell);
      }
    }
    return nextIteration;
  }
  
  void applyIteration(ArrayList<ArrayList<FluidCell>> nextIteration){
    //Systematically replace all values (And watch for mismatched sizes)
    if(nextIteration.size() != systemWidth)
      throw new IllegalArgumentException(String.format("The width of the given iteration (%s) does not match the width of the current iteration (%s).", nextIteration.size(), systemWidth));
    for(int x = 0; x < systemWidth; x++){
      if(nextIteration.get(x).size() != systemHeight)
        throw new IllegalArgumentException(String.format("The height of the given iteration's columns (%s) does not match the height of the current iterations' columns (%s).", nextIteration.get(x).size(), systemHeight));
      for(int y = 0; y < systemHeight; y++){
        cellColumns.get(x).get(y).replaceFluid(nextIteration.get(x).get(y).getAmount());
      }
    }
  }
  
  void render(color empty, color full){
    //Colours to render with are specified on-the-fly, which makes it easier to make it look pretty(?)
    camera.renderSystem(empty, full);
  }
  
  class FluidCell{
    private final float maximumAmount;
    private float fluidAmount;
    
    FluidCell(float maximumAmount){
      this(maximumAmount, 0);
    }
    
    FluidCell(float maximumAmount, float startingAmount){
      if(startingAmount < 0 || startingAmount > maximumAmount)
        throw new IllegalArgumentException(String.format("The given fluid amount %s is either below 0 or above the given maximum amount %s.", startingAmount, maximumAmount));
      this.maximumAmount = maximumAmount;
      fluidAmount = startingAmount;
    }
    
    float getMax(){
      return maximumAmount;
    }
    
    float getAmount(){
      return fluidAmount;
    }
     
    //Fancy names for add/subtract functions were an arbitrary decision
    void generateFluid(float amount){
      fluidAmount += amount;
      fluidAmount = constrain(fluidAmount, 0, maximumAmount);
    }
    
    void siphonFluid(float amount){
      generateFluid(-amount);
    }
    
    void replaceFluid(float amount){
      fluidAmount = amount;
      fluidAmount = constrain(fluidAmount, 0, maximumAmount);
    }
  }
  
  class SystemCamera{
    private final FluidSystem system;
    private final PVector origin;
    private float scalar;
    
    SystemCamera(FluidSystem targetSystem, PVector origin, float scalar){
      this.origin = origin.get();
      this.scalar = scalar;
      system = targetSystem;
    }
    
    SystemCamera(FluidSystem targetSystem, float x, float y, float scalar){
      origin = new PVector(x, y);
      this.scalar = scalar;
      system = targetSystem;
    }
    
    PVector getOrigin(){
      return origin.get();
    }
    
    float getScalar(){
      return scalar;
    }
    
    int scaleXtoIndex(float x){
      return floor((x-origin.x) / scalar);
    }
    
    int scaleYtoIndex(float y){
      return floor((y-origin.y) / scalar);
    }
    
    //Declaring mutable types as final only restricts changing the referenced object (x = y),
    //we can call methods and manipulate the object's fields.
    void setOrigin(PVector to){
      setOrigin(to.x, to.y);
    }
    
    void setOrigin(float x, float y){
      origin.set(x, y);
    }
    
    void setScalar(float to){
      scalar = to;
    }
    
    void offsetOrigin(PVector by){
      origin.add(by);
    }
    
    void offsetOrigin(float x, float y){
      offsetOrigin(new PVector(x, y));
    }
    
    void offsetScalar(float by){
      scalar += by;
      if(scalar<=0)
        scalar = 0.01;
    }
    
    void renderSystem(color empty, color full){
      //Iterate through all cells and render them with a colour based on their value.
      //Position is dependant on Origin, so we can move around as we wish.
      //Size is dependant on Scalar, so we can 'zoom' in/out as we wish.
      rectMode(CORNER);
      PVector location = origin.get();
      for(int x = 0; x < system.getWidth(); x++){
        for(int y = 0; y < system.getHeight(); y++){
          FluidCell cell = system.getCell(x, y);
          noStroke();
          fill(lerpColor(empty, full, cell.getAmount() / cell.getMax()));
          square(location, scalar);
          location.y += scalar;
        }
        location.y = origin.y;
        location.x += scalar;
      }
    }
  }
}

