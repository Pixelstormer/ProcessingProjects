/**
* Tower of Hanoi
* Program to solve the Tower of Hanoi puzzle
* with an arbitrary number of disks
* in the least possible moves.
*
* Press Space to start it,
* 's' to save instructions and exit once it's finished,
* and 'r' to reset it once it's finished.
*/

int disks=7;

//0=empty, disks=1,2,3... to number of disks
IntList tower1=new IntList();
IntList tower2=new IntList();
IntList tower3=new IntList();

int timer;
int interval=0;

int iterater=1;
String[] instructions = new String[int(pow(2,disks))];

void setup() {
  size(840, 560);
  frame.setResizable(true);
  rectMode(CENTER);
  textAlign(CENTER,CENTER);
  noLoop();
  
  timer=0;

  resetDisks();
  
  instructions[0]="Instructions for Tower of Hanoi puzzle with "+disks+" disks";
}

void draw() {
  background(0);
  drawTower(tower1);
  drawTower(tower2);
  drawTower(tower3);
}

void move(int disk, IntList source, IntList target, IntList spare){
  while(!(millis()-timer>interval)){}
  if(disk>0){
    move(disk-1,source,spare,target);
    moveDisk(source,target);
    move(disk-1,spare,target,source);
  }
  redraw();
  timer=millis();
}

void drawTower(IntList tower){
  stroke(44);
  strokeWeight(10);
  float x=width/4*getTowerIdentifier(tower);
  line(x,height/2+120,x,height/2-120);
  fill(200);
  text(getTowerIdentifier(tower),x+1,height/2-140);
  
  noStroke();
  for(int i=1;i<tower.size();i++){
    fill(102);
    rect(x,(height-135)-(34*i),(tower.get(i))*32,32,8);
    fill(200);
    text(tower.get(i),x,(height-135)-(34*i));
  }
}

void moveDisk(IntList source, IntList target) {
  int disk=getTopmostDisk(source);
  
  boolean isSourceEmpty=!(source.size()-1!=0);
  boolean isMoveValid=!(getTopmostDisk(target)>disk||getTopmostDisk(target)==0);
  
  if(isSourceEmpty) {
    println("Cannot move disk from tower "+getTowerIdentifier(source)+" to tower "+getTowerIdentifier(target)+" because tower is empty");
  }
  else if(isMoveValid){
    println("Cannot move disk from tower "+getTowerIdentifier(source)+" to tower "+getTowerIdentifier(target)+" because disk is larger than target disk");
  }
  else{
    source.remove(source.size()-1);
    target.append(disk);
    println("Move disk "+disk+" from tower "+getTowerIdentifier(source)+" to tower "+getTowerIdentifier(target));
    
    instructions[iterater]="Move disk "+disk+" from tower "+getTowerIdentifier(source)+" to tower "+getTowerIdentifier(target);
    iterater++;
  }
}

int getTowerIdentifier(IntList tower) {
  return tower.get(0);
}

int getTopmostDisk(IntList tower) {
  if (tower.size()-1!=0) {
    return tower.get(tower.size()-1);
  } else {
    return 0;
  }
}

boolean checkCompleted(){
  return tower3.size()==disks+1;
}

void resetDisks(){
  //Clear all towers clean
  tower1.clear();
  tower2.clear();
  tower3.clear();
  
  //Index 0 is reserved for tower 'identifiers'
  tower1.append(1);
  tower2.append(2);
  tower3.append(3);

  //Objective: Move all disks from towerA to towerC
  for (int i=disks; i>0; i--) {
    tower1.append(i);
  }
  
  redraw();
  iterater=1;
}


void keyPressed(){
  switch(key){
    case ' ':
      if(!(checkCompleted())){
        move(disks,tower1,tower3,tower2);
      }
      break;
    case 's':
    case 'S':
      if(checkCompleted()){
        saveStrings("instructions.txt",instructions);
        println("Saved instructions, exiting");
        exit();
      }
      break;
    case 'r':
    case 'R':
      if(checkCompleted()){
        resetDisks();
      }
      break;
  }
}

