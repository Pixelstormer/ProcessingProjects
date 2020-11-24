import java.io.File;
import java.util.Arrays;
import java.util.Collection;
import java.util.concurrent.ConcurrentSkipListSet;
import java.nio.file.Files;

final class FileElement implements Comparable<FileElement>{
  private final File file;
  private final File[] fileChildren;
  private FileState state;
  private ConcurrentSkipListSet<FileElement> children;
  
  public boolean childrenHidden;
  
  FileElement(File file){
    this.file = file;
    children = null;
    childrenHidden = true;
    fileChildren = file.listFiles();
    state = FileState.Not_Loaded;
  }
  
  public FileState loadState(){
    //long start = System.nanoTime();
    state = ((Files.isSymbolicLink(file.toPath())) ?
                FileState.Symbolic_Link
              : ((file.isDirectory()) ?
                   ((fileChildren == null) ?
                      FileState.Access_Denied
                     : ((fileChildren.length < 1) ?
                          FileState.Directory_Empty
                         : FileState.Directory))
                  : FileState.File));
    //long end = System.nanoTime();
    //System.out.printf("Loaded state '%s' for file '%s' in %d nanoseconds (%f milliseconds)%n", state, this, end - start, (end - start) / 1000000d);
    return state;
  }
  
  public ConcurrentSkipListSet<FileElement> loadChildren(){
    //children = wrapFiles(fileChildren);
    children = new ConcurrentSkipListSet<FileElement>();
    insertFiles(fileChildren, children);
    if(file.isDirectory() && fileChildren == null)
      state = FileState.Access_Denied;
    return children;
  }
  
  public void unloadChildren(){
    children = null;
  }
  
  public ConcurrentSkipListSet<FileElement> getChildren(){
    return children;
  }
  
  public File getFile(){
    return file;
  }
  
  public FileState getState(){
    return state;
  }
  
  public void setState(FileState state){
    this.state = state;
  }
  
  public int compareTo(FileElement other){
    return file.compareTo(other.getFile());
  }
  
  @Override
  public String toString(){
    return ((file.getName().trim().equals("")) ? file.toString() : file.getName());
  }
  
  public enum FileState{
    File,
    Directory,
    Access_Denied,
    Symbolic_Link,
    Directory_Empty,
    Not_Loaded
  }
  
  static public ConcurrentSkipListSet<FileElement> wrapFiles(Collection<File> files){
    if(files == null)
      return null;
      
    ConcurrentSkipListSet<FileElement> elements = new ConcurrentSkipListSet<FileElement>();
    
    for(File f : files)
      elements.add(new FileElement(f));
    
    return elements;
  }
  
  static public ConcurrentSkipListSet<FileElement> wrapFiles(File[] files){
    if(files == null)
      return null;
    
    return wrapFiles(Arrays.asList(files));
  }
  
  static public boolean insertFiles(Collection<File> from, ConcurrentSkipListSet<FileElement> to){
    if(from == null)
      return false;
    
    if(to == null)
      return false;
    
    for(File f : from)
      to.add(new FileElement(f));
    
    return true;
  }
  
  static public boolean insertFiles(File[] from, ConcurrentSkipListSet<FileElement> to){
    if(from == null)
      return false;
    
    if(to == null)
      return false;
    
    return insertFiles(Arrays.asList(from), to);
  }
}

