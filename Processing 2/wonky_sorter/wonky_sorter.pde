IntList data=new IntList();
int amount=20;
boolean showSmallest,showLargest;

void setup(){
  size(640,520);
  frame.setResizable(true);
  for(int i=1;i<=amount;i+=1){
    data.append(i);
  }
}

void draw(){
  background(0);
  int x=5;
  for(int i : data){
    if((showSmallest && i==data.min()) ||
       (showLargest  && i==data.max())) {
      fill(0,255,0);
      
      stroke(0,255,0);
      line(x+10,height,x+10,0);
      stroke(0);
    }
    else{
      fill(255);
    }
    
    rect(x,height,20,map(-i,0,amount,20,height/1.25));
    x+=width/amount;
  }
}

void sortList(IntList list){
  int index=0;
  for(int i : list){
    int dindex=0;
    int replace=list.get(index);
    for(int j : list){
      if(i-j==1){
        list.set(dindex+1,i);
        list.set(index,replace);
      }
      dindex++;
    }
    index++;
  }
  
}

void keyPressed(){
  switch(key){
    case ' ':
      data.shuffle();
      break;
    case 's':
      data.sort();
      break;
    case 'r':
      data.sortReverse();
      break;
    case 'm':
      showSmallest=!(showSmallest);
      break;
    case 'l':
      showLargest=!(showLargest);
      break;
    case 'a':
      sortList(data);
      break;
  }
}

