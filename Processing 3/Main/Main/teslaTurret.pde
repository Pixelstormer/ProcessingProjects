void teslaHandler(){
  //Handles the tesla moving
  teslaX = teslaX + ( Xspeed * Xdirection );
  teslaY = teslaY + ( Yspeed * Ydirection );
  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1
  if (teslaX > width-15 || teslaX < 15) {
    Xdirection *= -1;
  }
  if (teslaY > height-15 || teslaY < 15) {
    Ydirection *= -1;
  }
  
  //Renders the Tesla and range indicator
  strokeRed=random(0,64);
  strokeGreen=random(0,191);
  noStroke();
  fill(100,0,0,100);
  ellipse(teslaX,teslaY,teslaRange*2,teslaRange*2);
  stroke(255);
  noFill();
  ellipse(teslaX,teslaY,15,15);
  
  //Handles tesla hitting
  if(overCircle(teslaX,teslaY,teslaRange*2)){//Tesla deals damage even if Hit
    noFill();
    stroke(strokeRed,strokeGreen,255);
    curve(random(-noise,noise),random(-noise,noise),teslaX,teslaY,targX,targY,random(-noise,noise),random(-noise,noise));
    curve(random(-noise,noise),random(-noise,noise),teslaX,teslaY,targX,targY,random(-noise,noise),random(-noise,noise));
    hit(1);
  }
}