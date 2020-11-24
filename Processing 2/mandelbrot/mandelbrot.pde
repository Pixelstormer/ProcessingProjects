import java.math.BigDecimal;
import java.math.MathContext;

int iterations = 1;
double max = 4;
color first = color(0, 255, 0);
color second = color(255, 0, 0);
color[] colours;

double scalar = 1;
double scaleFactor = 0.1;

double xOffset = 0;
double yOffset = 0;

int iterOffset = 1;
double maxScalar = 1.2;

BigDecimal bigmax;

BigDecimal bigscalar;
BigDecimal bigscaleFactor;

BigDecimal bigxOffset;
BigDecimal bigyOffset;

BigDecimal horizontalLength;
BigDecimal verticalLength;

boolean useBig = true;

void setup() {
  size(840, 560);
  frame.setResizable(true);

  colours = new color[] {
    color(255, 0, 0), 
    color(255, 255, 0), 
    color(0, 255, 0), 
    color(0, 255, 255), 
    color(0, 0, 255)
  };

  bigmax = new BigDecimal(4);

  bigscalar = new BigDecimal(1);
  bigscaleFactor = new BigDecimal(0.1);

  bigxOffset = BigDecimal.ZERO;
  bigyOffset = BigDecimal.ZERO;

  horizontalLength = new BigDecimal(-2.5);
  verticalLength = new BigDecimal(-1);

  background(255);
  noLoop();
  redraw();
}

void draw() {
//  long t = millis();
//  println(String.format("Starting render at %sms...", t));
  if(useBig){
    bigrender();
  }
  else{
    render();
  }
//  long e = millis();
//  println(String.format("Render finished at %sms. Time taken: %sms.", e, e - t));
}

synchronized void render() {
  loadPixels();

  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      double mx = dmap(x, 0, width, -2.5 * scalar + xOffset, 1 * scalar + xOffset);
      double my = dmap(y, 0, height, -1 * scalar + yOffset, 1 * scalar + yOffset);
      int value = fc(mx, my, iterations, max);
      if (value == -1) {
        pixels[y*width+x] = color(0);
        continue;
      }
      pixels[y*width+x] = lerpColor(colours, normalize(value, 0, iterations));
    }
  }

  updatePixels();
}

synchronized void bigrender() {
  loadPixels();

  BigDecimal bigWidth = new BigDecimal(width);
  BigDecimal bigHeight = new BigDecimal(height);

  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      
      BigDecimal bigx = bigmap(new BigDecimal(x), BigDecimal.ZERO, bigWidth, horizontalLength.multiply(bigscalar).add(bigxOffset), bigscalar.add(bigxOffset));
      BigDecimal bigy = bigmap(new BigDecimal(y), BigDecimal.ZERO, bigHeight, verticalLength.multiply(bigscalar).add(bigyOffset), bigscalar.add(bigyOffset));
      
      int value = bigfc(bigx, bigy, iterations, bigmax);
      if (value == -1) {
        pixels[y*width+x] = 0;
        continue;
      }
      pixels[y*width+x] = lerpColor(colours, normalize(value, 0, iterations));
    }
  }

  updatePixels();
}

double dnormalize(double value, double min, double max) {
  return (value - min) / (max - min);
}

float normalize(float value, float min, float max) {
  return (value - min) / (max - min);
}

BigDecimal bignormalize(BigDecimal value, BigDecimal min, BigDecimal max) {
  return value.subtract(min).divide(max.subtract(min), MathContext.DECIMAL128);
}

color lerpColor(color[] arr, float step) {
  int sz = arr.length;
  if (sz == 1 || step <= 0.0) {
    return arr[0];
  } else if (step >= 1.0) {
    return arr[sz - 1];
  }
  float scl = step * (sz - 1);
  int i = int(scl);
  return lerpColor(arr[i], arr[i + 1], scl - i);
}

int fc(double x, double y, int iterations, double max) {
  double mx = 0;
  double my = 0;
  for (int i=0; i<iterations; i++) {
    double ox = dsq(mx) - dsq(my) + x;
    my = 2 * mx * my + y;
    mx = ox;

    if (dsq(mx) + dsq(my) > max)
      return i;
  }
  return -1;
}

int bigfc(BigDecimal x, BigDecimal y, int iterations, BigDecimal max) {
  BigDecimal mx = BigDecimal.ZERO;
  BigDecimal my = BigDecimal.ZERO;
  
  for (int i=0; i<iterations; i++) {
    
    BigDecimal ox = mx.pow(2).subtract(my.pow(2)).add(x);
    my = mx.multiply(my).multiply(new BigDecimal(2)).add(y);
    mx = ox;
    
    if (mx.pow(2).add(my.pow(2)).compareTo(max) > 0)
      return i;
      
//    BigDecimal ox = mx.multiply(mx).subtract(my.multiply(my)).add(x);
//    my = mx.multiply(my).multiply(new BigDecimal(2)).add(x);
//    mx = ox;
//    
//    if (mx.multiply(mx).add(my.multiply(my)).compareTo(max) > 0)
//      return i;
  }
  return -1;
}

double dmap(double value, double min1, double max1, double min2, double max2) {
  return min2 + (max2 - min2) * ((value - min1) / (max1 - min1));
}

double unmap(double value, double min1, double max1, double min2, double max2){
  return ((-min1)*max2 + min1*value + max1*min2 - max1*value) / (min2-max2);
}

BigDecimal bigmap(BigDecimal value, BigDecimal min1, BigDecimal max1, BigDecimal min2, BigDecimal max2) {
  return value.subtract(min1).divide(max1.subtract(min1), MathContext.DECIMAL128).multiply(max2.subtract(min2)).add(min2);
}

BigDecimal bigunmap(BigDecimal value, BigDecimal min1, BigDecimal max1, BigDecimal min2, BigDecimal max2) {
  return min1.negate().multiply(max2).add(min1.multiply(value)).add(max1.multiply(min2)).subtract(max1.multiply(value)).divide(min2.subtract(max2), MathContext.DECIMAL128);  
}

double dsq(double v) {
  return v*v;
}

void scaleMax(double amount){
  if(useBig){
    bigscaleMax(new BigDecimal(amount));
    return;
  }
  
  max *= amount;
}

void bigscaleMax(BigDecimal amount){
  bigmax.multiply(amount);
}

synchronized void zoom(int amount) {
  if (useBig) {
    bigzoom(new BigDecimal(amount));
    return;
  }

  scalar -= scaleFactor * scalar * amount;

  xOffset += map(mouseX, 0, width, -1, 1) * scalar;
  yOffset += map(mouseY, 0, height, -1, 1) * scalar;

  redraw();
}

synchronized void bigzoom(BigDecimal amount) {
  bigscalar = bigscalar.subtract(bigscaleFactor.multiply(bigscalar).multiply(amount));

  bigxOffset = bigxOffset.add(new BigDecimal(map(mouseX, 0, width, -1, 1)).multiply(bigscalar));
  bigyOffset = bigyOffset.add(new BigDecimal(map(mouseY, 0, height, -1, 1)).multiply(bigscalar));

  redraw();
}

synchronized void handleKeyPressed(char key) {
  switch(key) {
    //    case CODED:
    //      switch(keyCode){
    //        
    //      }
    //      break;
  case '=':
  case '+':
    iterations += iterOffset;
    break;
  case '-':
  case '_':
    iterations -= iterOffset;
    break;
  case 'i':
  case 'I':
    scaleMax(maxScalar);
    break;
  case 'o':
  case 'O':
    scaleMax(1/maxScalar);
    break;
  }
  redraw();
}

void mousePressed() {
  switch(mouseButton) {
  case LEFT:
    zoom(1);
    break;
  case RIGHT:
    zoom(-1);
    break;
  }
}

void mouseWheel(MouseEvent event) {
  zoom(-event.getCount());
}

void keyPressed() {
  handleKeyPressed(key);
}