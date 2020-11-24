void setup() {
  println(MPer(35)); //<>//
}

int MPer(int number){
  return MPer(number,0); //<>//
}

int MPer(int number, int count) {
  if (abs(number)<10) return count; //<>//
  int product = 1; //<>//
  String numString = str(number); //<>//
  int len = numString.length();
  if(len<=1) return count;
  for (int i=0; i<len; i++) { //<>//
    product *= numString.charAt(i); //<>//
  } //<>//
  println(number); //<>//
  return MPer(product, count+1); //<>//
}