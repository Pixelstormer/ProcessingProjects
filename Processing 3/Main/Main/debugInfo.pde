boolean debug=false;//Whether to display debug info

void debug(){
  //Debug info
  textSize(11.5);
  fill(255);
  textAlign(LEFT);
  if(debug){
    text("Mouse coordinates (X,Y): (" +mouseX+","+mouseY+")",4,15);//Mouse coordinates
    text("Pmouse coordinates (X,Y): ("+pmouseX+","+pmouseY+")",4,30);//PMouse coordinates
    text("Mouse coord difference: "+(round(dist(pmouseX,pmouseY,mouseX,mouseY))),4,45);//Difference between Mouse and PMouse coords, rounded
    text("Exact difference: "+dist(pmouseX,pmouseY,mouseX,mouseY),4,60);//Exact difference between Mouse and PMouse coords
    text("Laser coordinates: X: "+laserX+", Y: "+laserY,4,75);//Coords of laser turret
    text("Count to next shot: "+countDown,4,90);//Countdown to next laser turret shot
    text("Hit: "+hit,4,105);//Boolean if currently hit or not
    text("I-Frames remaining: "+hitTimer,4,120);//Time remaining until 'invincibility' wears off
    text("Tesla coordinates: X: "+teslaX+", Y: "+teslaY,4,135);//Coords of tesla turret
    text("Tesla noise level: "+noise,4,150);//Noise level for tesla electricity
    text("Distance to tesla: "+dist(mouseX,mouseY,teslaX,teslaY),4,165);//Distance from mouse to tesla turret
    text("Tesla range: "+teslaRange,4,180);//Range of the tesla turret
    text("Damage taken: "+damage,4,195);//Total 'damage' taken
    text("Charge: "+charge,4,210);//Responsible for laser turret charge visualisation
    text("Angle: "+laserAngle,4,225);//Angle of turret barrel
    text("Laser tele chance: "+teleChance,4,240);//Chance for laser to teleport upon firing
    text("Laser teleport threshhold: "+teleThreshhold,4,255);
    text("Rockets alive: "+shooter.size(),4,270);

    line(trackX+10,trackY,trackX-10,trackY);//Crosshair that shows
    line(trackX,trackY+10,trackX,trackY-10);//laser turret aiming reticule
    line(width/2,0,width/2,height);//Cross showing
    line(0,height/2,width,height/2);//center of screen
  }
  text("Debug toggle: "+debug,4,height-4);//Whether or not Debug info is toggled on or off
}