final class FileBrowser{
  final color DIRECTORY_COLOUR = color(75, 255, 75);
  final color FILE_COLOUR = color(255);
  final color NO_ACCESS_COLOUR = color(255, 75, 75);
  final color SYMBOLIC_LINK_COLOUR = color(75, 75, 255);
  final color EMPTY_DIRECTORY_COLOUR = color(255, 150, 75);
  final color NOT_LOADED_COLOUR = color(150, 75, 150);
  
  private final HashMap<FileElement.FileState, Integer> stateColours;
  private final ConcurrentSkipListSet<FileElement> roots;
  
  private final PImage settingsIcon;
  
  float x;
  float y;
  float lineMargin;
  float tabMargin;
  
  boolean settingsOpen;
  
  FileBrowser(float x, float y, float lineMargin, float tabMargin, PImage settingsIcon, Collection<FileElement> roots){
    this.x = x;
    this.y = y;
    this.lineMargin = lineMargin;
    this.tabMargin = tabMargin;
    this.roots = new ConcurrentSkipListSet<FileElement>(roots);
    this.settingsIcon = settingsIcon;
    settingsOpen = false;
    stateColours = new HashMap<FileElement.FileState, Integer>(6, 1);
    stateColours.put(FileElement.FileState.File, FILE_COLOUR);
    stateColours.put(FileElement.FileState.Directory, DIRECTORY_COLOUR);
    stateColours.put(FileElement.FileState.Access_Denied, NO_ACCESS_COLOUR);
    stateColours.put(FileElement.FileState.Symbolic_Link, SYMBOLIC_LINK_COLOUR);
    stateColours.put(FileElement.FileState.Directory_Empty, EMPTY_DIRECTORY_COLOUR);
    stateColours.put(FileElement.FileState.Not_Loaded, NOT_LOADED_COLOUR);
  }
  
  FileBrowser(float x, float y, float lineMargin, float tabMargin, PImage settingsIcon, FileElement... roots){
    this(x, y, lineMargin, tabMargin, settingsIcon, Arrays.asList(roots));
  }
  
  void render(){
    recursiveRender(x, y, lineMargin, tabMargin, roots);
    renderSettings();
  }
  
  private float recursiveRender(float x, float y, float lineMargin, float tabMargin, ConcurrentSkipListSet<FileElement> files){
    if(files == null)
      return 0;
    textAlign(LEFT, TOP);
    noSmooth();
    float origin = y;
    float verticalIncrement = textHeight() + lineMargin;
    for(FileElement f : files){
      if(y > -verticalIncrement && y < height){
        color colour = stateColours.get(f.getState());
        fill(colour);
        stroke(colour);
        if(colour == NOT_LOADED_COLOUR)
          invokeNoArgMethodOnThread(f, "loadState");
//        switch(f.getState()){
//          case File:
//            fill(FILE_COLOUR);
//            stroke(FILE_COLOUR);
//            break;
//          case Directory:
//            fill(DIRECTORY_COLOUR);
//            stroke(DIRECTORY_COLOUR);
//            break;
//          case Access_Denied:
//            fill(NO_ACCESS_COLOUR);
//            stroke(NO_ACCESS_COLOUR);
//            break;
//          case Symbolic_Link:
//            fill(SYMBOLIC_LINK_COLOUR);
//            stroke(SYMBOLIC_LINK_COLOUR);
//            break;
//          case Directory_Empty:
//            fill(EMPTY_DIRECTORY_COLOUR);
//            stroke(EMPTY_DIRECTORY_COLOUR);
//            break;
//          default:
//            fill(NOT_LOADED_COLOUR);
//            stroke(NOT_LOADED_COLOUR);
//            invokeNoArgMethodOnThread(f, "loadState");
//            break;
//        }
        text("• "+f.toString(), x, y);
        if(y < mouseY && mouseY - y < verticalIncrement){
          noFill();
          boolean settingsRendered = pointIntersectsRectangle(mouseX, mouseY, width - settingsWidth/2 - 4, settingsHeight/2 + 4, settingsWidth + 32, settingsHeight + 32);
          rect(2, y-2, width - 4 - ((settingsRendered) ? settingsWidth + 4 : 0), verticalIncrement);
        }
      }
      y += verticalIncrement;
      if(!f.childrenHidden)
        y += recursiveRender(x + tabMargin, y, lineMargin, tabMargin, f.getChildren());
    }
    return y - origin;
  }
  
  private void renderSettings(){
    if(!pointIntersectsRectangle(mouseX, mouseY, width - settingsWidth/2 - 4, settingsHeight/2 + 4, settingsWidth + 32, settingsHeight + 32))
      return;
    smooth();
    tint(((pointIntersectsRectangle(mouseX, mouseY, width - settingsWidth/2 - 4, settingsHeight/2 + 4, settingsWidth, settingsHeight))
         ? #c7dbe8
         : #99aab5));
    imageMode(CENTER);
    image(settingsIcon, width - settingsWidth/2 - 4, settingsHeight/2 + 4, settingsWidth, settingsHeight);
  }
  
  FileElement findElementAt(float targetY){
    FileElement[] out = new FileElement[1];
    findElementAt(targetY, y, roots, out);
    return out[0];
  }
  
  private float findElementAt(float targetY, float y, ConcurrentSkipListSet<FileElement> files, FileElement[] out){
    if(files == null)
      return 0;
    float origin = y;
    float verticalIncrement = textHeight() + lineMargin;
    for(FileElement f : files){
      if(y < targetY && targetY - y < verticalIncrement){
        out[0] = f;
        return y - origin;
      }
      y += verticalIncrement;
      if(!f.childrenHidden)
        y += findElementAt(targetY, y, f.getChildren(), out);
      if(out[0] != null)
        return y-origin;
    }
    return y - origin;
  }
}

