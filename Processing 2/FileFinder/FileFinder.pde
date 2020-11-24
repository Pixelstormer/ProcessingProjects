/*
Listed available roots ACCORDING TO File.listRoots():
C:\
D:\
H:\
U:\
*/

try{
  for(File f : File.listRoots()){
    String root = f.toString();
    //Skipping C: can sometimes be desirable due to the huge size compared to other directories
    //if(root.equals("C:\\")) continue;
    Find.main(new String[]{
      root,
      "-name",
      "SHELL32.DLL"
    });
  }
}
catch(IOException e){
  e.printStackTrace();
}

exit();

