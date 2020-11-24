String fileName;

String[] files;
byte[] fileContents;

void setup(){
  size(840,560);
  surface.setResizable(true);
  
  selectFolder("Select file to read", "getFile");
}

void draw(){
  background(0);
}

void getFile(File selection){
  files = selection.list();
}