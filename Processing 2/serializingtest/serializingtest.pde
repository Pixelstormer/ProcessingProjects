import java.io.*;

box Box;
circle Circle;

String fileName = "serialized.ser";

void setup() {
  size(840, 560);
  frame.setResizable(true);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  Box = new box(50, "box", this);
  Circle = new circle(50, "circle", this);
}

void draw() {
  background(0);
  Box.render(100, 100);
  Circle.render(200, 100);
}

void mousePressed() {
  try
  {  
    println("Begin");
    //Saving of object in a file 
    File fileobj = new File(dataPath(fileName));
    println("Made file");
    println("File path: "+fileobj.getAbsolutePath());
    FileOutputStream file = new FileOutputStream(fileobj); 
    println("Made file stream");
    ObjectOutputStream out = new ObjectOutputStream(file); 
    println("Made object stream");

    // Method for serialization of object 
    out.writeObject(Box);
    println("Written box");
    out.writeObject(Circle); 
    println("Written circle");

    out.close(); 
    println("Closed object stream");
    file.close(); 
    println("Closed file stream");

    System.out.println("Complete");
  } 

  catch(IOException ex) 
  { 
    ex.printStackTrace();
  }
}

void keyPressed() {
  try
  {    
    // Reading the object from a file
    println("Begin de");
    File fileobj = new File(dataPath(fileName));
    println("Made de file");
    println("De file path: "+fileobj.getAbsolutePath());
    FileInputStream file = new FileInputStream(fileobj);
    println("Made input stream"); 
    ObjectInputStream in = new ObjectInputStream(file); 
    println("Made obj in stream");

    // Method for deserialization of object 
    box object1 = (box)in.readObject(); 
    println("Retrieved box");
    circle obj2 = (circle)in.readObject();
    println("Retrieved circle");


    in.close();
    println("Closed in"); 
    file.close(); 
    println("Closed file");

    println("Complete"); 
    println("box size = " + object1.getSize()); 
    println("box text = " + object1.getText());
    println("circle size: " + obj2.getSize());
    println("circle text: " + obj2.getText());
  } 

  catch(IOException ex) 
  { 
    ex.printStackTrace();
  } 

  catch(ClassNotFoundException ex) 
  { 
    ex.printStackTrace();
  }
}

