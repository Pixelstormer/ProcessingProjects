import java.util.Collection;
import java.util.Arrays;
import java.util.concurrent.ConcurrentSkipListSet;
import java.lang.reflect.InvocationTargetException;
//import java.awt.Desktop;

final float xIndent = 4;
final float yIndent = 4;
final float lineSpacing = 2;
final float tabSpacing = 16;

final float scrollSpeed = 64;

FileBrowser browser;

final float settingsWidth = 15;
final float settingsHeight = 15;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  textFont(loadFont("CourierNoSmooth.vlw"), g.textSize);
  
  PImage settingsIcon = loadImage("triple_gears_inverted.png");
  
  browser = new FileBrowser(xIndent, yIndent, lineSpacing, tabSpacing, settingsIcon, FileElement.wrapFiles(File.listRoots()));
}

void draw(){
  background(0);
  browser.render();
}

float textHeight(){
  return textAscent() + textDescent();
}

float lineHeight(){
  return textAscent() + textDescent() + lineSpacing;
}

static boolean pointIntersectsRectangle(float pointX, float pointY, float centerX, float centerY, float rectWidth, float rectHeight){
  return pointX >= centerX - rectWidth/2
      && pointX <= centerX + rectWidth/2
      && pointY >= centerY - rectHeight/2
      && pointY <= centerY + rectHeight/2;
}

static boolean pointIntersectsEllipse(float pointX, float pointY, float circleX, float circleY, float circleXRadius, float circleYRadius){
  return ( sq(pointX-circleX) / sq(circleXRadius) ) + ( sq(pointY-circleY) / sq(circleYRadius) ) <= 1;
}

static <C> void invokeNoArgMethodOnThread(final C target, final String methodName){
  new Thread(){
    @Override
    public void run(){
      try{
        target.getClass().getMethod(methodName, new Class[]{}).invoke(target, new Object[]{});
      }
//      catch (IllegalArgumentException e) {
//        e.printStackTrace();
//      }
//      catch (IllegalAccessException e) {
//        e.printStackTrace();
//      }
      catch (InvocationTargetException e) {
        e.getTargetException().printStackTrace();
      }
//      catch (NoSuchMethodException e) {
//        e.printStackTrace();
//      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  }.start();
}

void mousePressed(){
  FileElement element = browser.findElementAt(mouseY);
  if(element != null){
    if(element.getState() == FileElement.FileState.Directory || element.getState() == FileElement.FileState.Symbolic_Link){
      if(element.getChildren() == null)
        invokeNoArgMethodOnThread(element, "loadChildren");
      element.childrenHidden = !element.childrenHidden;
    }
    else{
      try{
        //Desktop.getDesktop().open(element.getFile());
        Process process = Runtime.getRuntime().exec("rundll32 SHELL32.DLL,ShellExec_RunDLL \"" + element.getFile().getAbsolutePath() + "\"");
      }
      catch(IOException e){
        e.printStackTrace();
        element.setState(FileElement.FileState.Access_Denied);
      }
    }
    
//    if(element.getFile().isFile()){
//      try{
//        //Desktop.getDesktop().open(element.getFile());
//        Process process = Runtime.getRuntime().exec("rundll32 SHELL32.DLL,ShellExec_RunDLL \"" + element.getFile().getAbsolutePath() + "\"");
//      }
//      catch(IOException e){
//        e.printStackTrace();
//        element.setState(FileElement.FileState.Access_Denied);
//      }
//    }
//    else{
//      if(element.getChildren() == null)
//        invokeNoArgMethodOnThread(element, "loadChildren");
//      element.childrenHidden = !element.childrenHidden;
//    }
  }
}

void mouseWheel(MouseEvent event){
  browser.y -= event.getCount() * scrollSpeed;
}

