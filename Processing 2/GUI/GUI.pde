import g4p_controls.*;

GButton menu,exit,sub;
GCustomSlider backgroundRed,backgroundBlue,backgroundGreen;

String state;

int bgRed,bgBlue,bgGreen;

void setup(){
  size(640,480);
  frame.setResizable(true);
  
  menu=new GButton(this,width/2-60/2,80,60,45,"Enter submenu");
  menu.setTextAlign(GAlign.CENTER,null);
  
  exit=new GButton(this,width/2-60/2,height-80,60,45,"Close program");
  
  sub=new GButton(this,width/2-80/2,height/1.5,80,65,"Exit submenu");
  sub.setLocalColorScheme(1);
  sub.setVisible(false);
  
  backgroundRed=new GCustomSlider(this,width/2-200/2,20,200,50,"grey_blue");
  backgroundRed.setShowDecor(false,false,true,true);
  backgroundRed.setEasing(4);
  backgroundRed.setLimits(0,255);
  backgroundRed.setVisible(false);
  backgroundRed.setValue(bgRed);
  backgroundRed.setLocalColorScheme(0);
  
  backgroundGreen=new GCustomSlider(this,width/2-200/2,65,200,50,"grey_blue");
  backgroundGreen.setShowDecor(false,false,true,true);
  backgroundGreen.setEasing(4);
  backgroundGreen.setLimits(0,255);
  backgroundGreen.setVisible(false);
  backgroundGreen.setValue(bgGreen);
  backgroundGreen.setLocalColorScheme(1);
  
  backgroundBlue=new GCustomSlider(this,width/2-200/2,110,200,50,"grey_blue");
  backgroundBlue.setShowDecor(false,false,true,true);
  backgroundBlue.setEasing(4);
  backgroundBlue.setLimits(0,255);
  backgroundBlue.setValue(bgBlue);
  backgroundBlue.setVisible(false);
}

void draw(){
  background(bgRed,bgGreen,bgBlue);
  noFill();
  stroke(255);
  strokeWeight(2);
  ellipse(mouseX,mouseY,15,15);
  point(mouseX,mouseY);
  if(backgroundGreen.getValueI()<100){
    backgroundGreen.setValue(backgroundGreen.getValueI()+1);
  }else if(backgroundGreen.getValueI()>100){
    backgroundGreen.setValue(backgroundGreen.getValueI()-2);
  }
}

void handleButtonEvents(GButton button,GEvent event){
  if(button==menu){
    menu.setVisible(false);
    exit.setVisible(false);
    sub.setVisible(true);
    backgroundRed.setVisible(true);
    backgroundBlue.setVisible(true);
    backgroundGreen.setVisible(true);
  }
  if(button==sub){
    sub.setVisible(false);
    menu.setVisible(true);
    exit.setVisible(true);
    backgroundRed.setVisible(false);
    backgroundBlue.setVisible(false);
    backgroundGreen.setVisible(false);
  }
  if(button==exit){
    exit();
  }
}

void handleSliderEvents(GValueControl slider,GEvent event){
  if(slider==backgroundRed){
    bgRed=slider.getValueI();
  }
  if(slider==backgroundGreen){
    bgGreen=slider.getValueI();
  }
  if(slider==backgroundBlue){
    bgBlue=slider.getValueI();
  }
}
