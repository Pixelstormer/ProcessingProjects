import java.io.File;

final float RED_WEIGHT = 0.2126;
final float GREEN_WEIGHT = 0.7152;
final float BLUE_WEIGHT = 0.0722;

PImage[] images;
PImage[] greyImages;
PImage[] bayerImages;
int index;
float downScalar = 1;
int paletteSize = 4;

PGraphics screen;

void setup() {
  size(840, 560);
  frame.setResizable(true);
  colorMode(RGB, 1.0);
  noSmooth();
  paletteSize--;
  
  println("PROGRAM STARTED.\n");

  loadImages();
}

String[] loadFiles(){
  File dataFile = new File(dataPath(""));
  return dataFile.list();
}

void loadImages(){
  println("STARTING LOADING IMAGES");
  float startTime = millis();
  
  String[] files = loadFiles();
  
  println("LOADED FILES. NUMER OF FILES LOADED: "+files.length);
  println("LOADED FILES:");
  for(String s : files){
    println(s);
  }
  
  images = new PImage[files.length];
  greyImages = new PImage[files.length];
  bayerImages = new PImage[files.length];
  
  for (int i=0, j=files.length; i<j; i++) {
    println("\nBEGIN LOADING FILE NUMBER "+i+" WITH NAME '"+files[i]+"'");
    String[] split = files[i].split("\\.");
    String extension = split[split.length-1].toLowerCase();
    if(!(extension.equals("gif") || extension.equals("jpg") || extension.equals("tga") || extension.equals("png"))){
      println("WARNING: IMAGE '"+files[i]+"' HAS INCOMPATIBLE EXTENSION '."+extension+"'. THIS FILE WILL BE SKIPPED.");
      i++;
    }
    images[i] = loadImage(files[i]);
    greyImages[i] = convertImageToGreyScale(images[i]);
    bayerImages[i] = convertGreyScaleImageToDithered(greyImages[i],paletteSize);
    println("FINISHED LOADING FILE NUMBER "+i+" WITH NAME '"+files[i]+"'");
  }
  
  float time = millis()-startTime;
  println("\nIMAGES FINISHED LOADING");
  println("TOTAL TIME TAKEN: "+time+"ms\n");
}

void draw() {
  background(0);
  PImage i = images[index];
  while(i==null)
    i=images[++index];
  float gx = (i.width>i.height)?0:i.width;
  float gy = (i.width>i.height)?i.height:0;
  float w = gx+i.width;
  float h = gy+i.height;
  if (w>width || h>height) {
    float sw = min(w, width);
    float sh = min(h, height);
    float wd = w-sw;
    float hd = h-sh;
    float pd = (wd>hd)?width/w:height/h;
    w*=pd;
    h*=pd;
  }
  if (i.width>i.height) {
    h/=2;
  } else {
    w/=2;
  }
  gx = (w>h)?0:w;
  gy = (w>h)?h:0;

  image(i, 0, 0, w, h);
  //image(greyImages[index], gx, gy, w, h);
  image(bayerImages[index], gx, gy, w, h);

  //  screen.beginDraw();
  //  //screen.background(0);
  //  screen.fill(0.4,0.8,0.6);
  //  screen.ellipse(mouseX,mouseY,50,50);
  //  screen.endDraw();
  //  loadPixels();
  //  pixels = performGreyScaleTransformation(screen);
  //  updatePixels();
}

color[] performGreyScaleTransformation(PGraphics target) {
  target.loadPixels();
  color[] newPixels = convertPixelsToGreyScale(target.pixels);
  return newPixels;
}

PImage convertImageToGreyScale(PImage target) {
  println("\nCONVERTING IMAGE TO GREYSCALE");
  float startTime = millis();
  println("IMAGE DIMENSIONS: "+target.width+"x"+target.height);
  PImage workingImage = createImage(target.width, target.height, RGB);
  target.loadPixels();
  workingImage.loadPixels();
  for (int i=0, j=target.pixels.length; i<j; i++) {
    color c = target.pixels[i];
    float red = convertToLinear(red(c)); //c >> 16 & 0xFF;
    float green = convertToLinear(green(c)); //c >> 8 & 0xFF;
    float blue = convertToLinear(blue(c)); //c & 0xFF;


    float grey = convertFromLinear(RED_WEIGHT*red + GREEN_WEIGHT*green + BLUE_WEIGHT*blue);
    workingImage.pixels[i] = color(grey);
  }
  workingImage.updatePixels();
  float time = millis()-startTime;
  println("COMPLETED IMAGE CONVERSION TO GREYSCALE");
  println("TIME TAKEN: "+time+"ms\n");
  return workingImage;
}

PImage convertGreyScaleImageToDithered(PImage target, int paletteSize){
  println("\nSTART GREYSCALE -> DITHERED CONVERSION");
  float startTime = millis();
  println("TARGET IMAGE DIMENSIONS: "+target.width+"x"+target.height);
  target.resize(int(target.width/downScalar), 0);
  PImage workingImage = createImage(target.width, target.height, RGB);
  target.loadPixels();
  workingImage.loadPixels();
  float nextPow2W = ceil(log2(target.width));
  float nextPow2H = ceil(log2(target.height));
  int matrixWidth = int(pow(2, nextPow2W));
  int matrixHeight = int(pow(2, nextPow2H));
  println("BAYER MATRIX DIMENSIONS: "+matrixWidth+"x"+matrixHeight);
  int[][] matrix = generateBayerMatrix(matrixWidth, matrixHeight);
  float[] palette = new float[paletteSize+1];
  for(int i=0; i<paletteSize+1; i++){
    palette[i] = 1/float(paletteSize) * i;
  }  
  println("PALETTE SIZE: "+paletteSize);
  for(int i=0, j=target.pixels.length; i<j; i++){
    color colour = target.pixels[i];
    //As it is greyscale, all rgb will be the same
    float brightness = red(colour);
    color higherColour = color(getHigherClosestInSequence(palette, brightness));
    color lowerColour = color(getLowerClosestInSequence(palette, brightness));
    int x = i % target.width;
    int y = floor(i / target.width);
    float matrixValue = map(matrix[x][y],0,matrixWidth*matrixHeight,0,1);
    
    if(matrixValue<0 || matrixValue>=1){
      println(String.format("(%s,%s) == %s (%s) : %s",x,y,matrixValue,matrix[x][y],brightness));
    }
    //New colour = closest_colour_from_palette(brightness + colour_space_spread * (matrixValue-0.5))
    workingImage.pixels[i] = (brightness>=matrixValue)?higherColour:lowerColour;
  }
  workingImage.updatePixels();
  float time = millis()-startTime;
  println("GREYSCALE -> DITHERED CONVERSION FINISHED");
  println("TIME TAKEN: "+time+"ms\n");
  return workingImage;
}

int[][] generateBayerMatrix(int matrixWidth, int matrixHeight) {
  if (!isPowerOfTwo(matrixWidth)) throw new IllegalArgumentException(String.format("THE MATRIX WIDTH OF %s IS NOT A POWER OF 2", matrixWidth));
  if (!isPowerOfTwo(matrixHeight)) throw new IllegalArgumentException(String.format("THE MATRIX HEIGHT OF %s IS NOT A POWER OF 2", matrixHeight));
  int[][] resultingMatrix = new int[matrixWidth][matrixHeight];
  int M = int(log2(matrixWidth));
  int L = int(log2(matrixHeight));
  for (int y=0; y<matrixHeight; ++y) {
    for (int x=0; x<matrixWidth; ++x) {
      int cellValue = performMatrixCellValueCalculation(M, L, x, y);
      resultingMatrix[x][y] = cellValue;
    }
  }
  return resultingMatrix;
}

int performMatrixCellValueCalculation(int M, int L, int x, int y) {
  int cellValue = 0, offset=0, xmask = M, ymask = L;
  if (M==0 || (M > L && L != 0)) {
    int xc = x ^ ((y << M) >> L), yc = y;
    for (int bit=0; bit < M+L; ) {
      cellValue |= ((yc >> --ymask)&1) << bit++;
      for (offset += M; offset >= L; offset -= L) {
        cellValue |= ((xc >> --xmask)&1) << bit++;
      }
    }
  } else {
    int xc = x, yc = y ^ ((x << L) >> M);
    for (int bit=0; bit < M+L; ) {
      cellValue |= ((xc >> --xmask)&1) << bit++;
      for (offset += L; offset >= M; offset -= M) {
        cellValue |= ((yc >> --ymask)&1) << bit++;
      }
    }
  }
  return cellValue;
}

color[] convertPixelsToGreyScale(color[] target) {
  color[] workingArray = new color[target.length];
  for (int i=0, j=target.length; i<j; i++) {
    color c = target[i];
    float red = convertToLinear(red(c)); //c >> 16 & 0xFF;
    float green = convertToLinear(green(c)); //c >> 8 & 0xFF;
    float blue = convertToLinear(blue(c)); //c & 0xFF;


    float grey = convertFromLinear(RED_WEIGHT*red + GREEN_WEIGHT*green + BLUE_WEIGHT*blue);
    workingArray[i] = color(grey);
  }
  return workingArray;
}

float convertToLinear(float amt) {
  return (amt>0.04045)?pow((amt+0.055)/1.055, 2.4):amt/12.92;
}

float convertFromLinear(float amt) {
  return (amt>0.0031308)?1.055*pow(amt, 1/2.4)-0.055:12.92*amt;
}

boolean isPowerOfTwo(int x) {
  return (x!=0)&&((x&(x-1))==0);
}

float log2(float x) {
  return log(x)/log(2)+1e-10;
}

float getHigherClosestInSequence(float[] input, float value){
  float difference = Integer.MAX_VALUE;
  float closest = 0;
  for(float i : input){
    if(i<value) continue;
    float dif = abs(i-value);
    if(dif<difference){
      difference = dif;
      closest = i;
    }
  }
  return closest;
}

float getLowerClosestInSequence(float[] input, float value){
  float difference = Integer.MAX_VALUE;
  float closest = 0;
  for(float i : input){
    if(i>value) continue;
    float dif = abs(i-value);
    if(dif<difference){
      difference = dif;
      closest = i;
    }
  }
  return closest;
}

void mousePressed() {
  switch(mouseButton) {
  case LEFT:
    index++;
    break;
  case RIGHT:
    index--;
    break;
  }
  if (index>=images.length) index = 0;
  if (index<0) index = images.length-1;
}

void keyPressed(){
  switch(key){
    case '-':
    case '_':
      paletteSize--;
      if(paletteSize<2){
        paletteSize = 2;
        return;
      }
      bayerImages[index] = convertGreyScaleImageToDithered(greyImages[index],paletteSize);
      break;
    case '=':
    case '+':
      paletteSize++;
      bayerImages[index] = convertGreyScaleImageToDithered(greyImages[index],paletteSize);
      break;
  }
}

