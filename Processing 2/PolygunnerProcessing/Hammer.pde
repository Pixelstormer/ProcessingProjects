class Hammer{
  int h;
  int f;
  
  Hammer(){
    setHammer(1);
    f=0;
  }
  
  void setHammer(int n){
    h=(constrain(n,0,5)==n) ? n : 1;
  }
  
  void cooldown(){
    f--;
    if(abs(f)!=f){
      f=0;
    }
  }
  
  void trigger(PVector p){
    if(f<=0){
      switch(h){
        case 0: //Triangle
          triHammer(p);
          break;
        case 1: //Square
          squareHammer(p);
          break;
        case 2: //pentagon
          pentHammer(p);
          break;
        case 3: //Hexagon
          hexHammer(p);
          break;
        case 4: //Octagon
          octHammer(p);
          break;
        case 5: 
          octHammerAlt(p); //Octagon alt shot
          break;
        default:
          print("Hammer index is invalid! Valid indexes are: 0,1,2,3,4,5. Defaulting to 1...");
          setHammer(1);
          break;
      }
    }
  }
  
  void triHammer(PVector p){ //0
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),0);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),157.5);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),-157.5);
    
    f=10;
  }
  
  void squareHammer(PVector p){ //1
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),0);
    
    f=6;
  }
  
  void pentHammer(PVector p){ //2
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),0);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),45);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),-45);
    f=12;
  }
  
  void hexHammer(PVector p){ //3
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),0);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),180);
    f=8;
  }
  
  void octHammer(PVector p){ //4
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),0);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),90);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),-90);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),180);
    f=15;
    setHammer(5);
  }
  
  void octHammerAlt(PVector p){ //5
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),45);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),-45);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),135);
    fire(p,PVector.sub(new PVector(mouseX,mouseY),p),-135);
    f=15;
    setHammer(4);
  }
  
  void fire(PVector p,PVector d,float o){
    d.rotate(radians(o));
    b.add(new Bullet(p,d));
  }
}
