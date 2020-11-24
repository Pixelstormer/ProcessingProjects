int[][] matrix;
int size = 2;

//SIZE OF MATRIX FOR ANY IMAGE SHOULD BE THE NEXT CLOSEST POWERS OF 2
//For x: 2^log2(x) = x
//We want values where log2(x) is a whole integer
//Get log2 of value, then round up (Incase is fraction) then use as exponent for 2
//x = pow(2,ceil(log2(n)))

void setup() {
  size(840, 560);
  frame.setResizable(true);
//  matrix = generateBayerMatrix(size);
//  for (int x=0; x<size; x++) {
//    int[] i = matrix[x];
//    String r = "["+x+"]: ";
//    for (int y=0; y<size; y++) {
//      r += " ["+y+"]: "+"("+((i[y]>>16)&0xFF)+","+((i[y]>>8)&0xFF)+","+(i[y]&0xFF)+") ("+i[y]+")";
//    }
//    //println(r);
//  }
  
  int matrixWidth = pow(2, ceil(log2(n)));
  int matrixHeight = pow(2, ceil(log2(y)));

  int[][] m = generateMatrixCPP(4, 4);
}

//Translated from C++ to java, source from bisqwit.iki.fi/story/howto/dither/jy/
//Seems to work fine
//void generateMatricesExample() {
//  //Loop over x sizes
//  for (int M=0; M<=3; ++M) {
//    //Loop over y sizes
//    for (int L=0; L<=3; ++L) {
//
//      //Left shifts 1 by loop value, to ensure it is always power of 2
//      int xdim = 1 << M;
//      int ydim = 1 << L;
//
//      //Print x and y size, and total cells
//      println(String.format(" WIDTH = %s, HEIGHT = %s, TOTAL CELLS = %s:", xdim, ydim, xdim*ydim));
//
//      //Loop over each y cell in matrix
//      for (int y=0; y<ydim; ++y)
//      {
//        //Vertical bar prepended to each row of cells
//        print("\n   |");
//        //Loop over each x cell in matrix
//        for (int x=0; x<xdim; ++x)
//        {
//
//          int cellValue = 0, offset=0, xmask = M, ymask = L;                         
//          if (M==0 || (M > L && L != 0))
//          {
//            //First XOR
//            int xc = x ^ ((y << M) >> L), yc = y;
//            for (int bit=0; bit < M+L; )
//            {
//              cellValue |= ((yc >> --ymask)&1) << bit++;
//              for (offset += M; offset >= L; offset -= L)
//                cellValue |= ((xc >> --xmask)&1) << bit++;
//            }
//          } else
//          {   
//            //Second XOR
//            int xc = x, yc = y ^ ((x << L) >> M);
//            for (int bit=0; bit < M+L; )
//            {
//              cellValue |= ((xc >> --xmask)&1) << bit++;
//              for (offset += L; offset >= M; offset -= M)
//                cellValue |= ((yc >> --ymask)&1) << bit++;
//            }
//          }
//          //Print cell value, padded to ensure constant width
//          print(((cellValue<10)?" ":"")+cellValue+"|");
//        }
//      }
//    }
//  }
//}

int[][] generateMatrixCPP(int matrixWidth, int matrixHeight) {
  //Only works for powers of 2
  if (!isPowerOfTwo(matrixWidth)) throw new IllegalArgumentException(String.format("THE MATRIX WIDTH OF %s IS NOT A POWER OF 2", matrixWidth));
  if (!isPowerOfTwo(matrixHeight)) throw new IllegalArgumentException(String.format("THE MATRIX HEIGHT OF %s IS NOT A POWER OF 2", matrixHeight));

  int[][] resultingMatrix = new int[matrixWidth][matrixHeight];

  //Print x and y size, and total cells
  println("GENERATING BAYER MATRIX");
  println(String.format("WIDTH = %s, HEIGHT = %s, TOTAL CELLS = %s:", matrixWidth, matrixHeight, matrixWidth*matrixHeight));

  //Get exponents of dimensions
  int M = int(log2(matrixWidth));
  int L = int(log2(matrixHeight));
 
  /*
   """
   The value for slot (x, y) is calculated as follows:
   Take two values, the y coordinate and the XOR of x and y coordinates
   Interleave the bits of these two values in reverse order.
   Floating-point divide the result by N. (Optional, required by some algorithms but not all.)
   """
   */

  //M and L are the binary exponents for the width and height
  //ie. for width 2 and height 4 M is 1 and H is 2

  //Loop over each y cell in matrix
  for (int y=0; y<matrixHeight; ++y)
  {
    //Vertical bar prepended to each row of cells
    print("\n   |");

    //Loop over each x cell in matrix
    for (int x=0; x<matrixWidth; ++x) {
      //Get matrix value
      int cellValue = performMatrixCellValueCalculation(M, L, x, y);
      resultingMatrix[x][y] = cellValue;
      //Print cell value, padded to ensure constant width
      print(((cellValue<10)?" ":"")+cellValue+"|");
    }
  }
  return resultingMatrix;
}

int performMatrixCellValueCalculation(int matrixWidthExponent, int matrixLengthExponent, int x, int y) {
  int M = matrixWidthExponent, L = matrixLengthExponent, cellValue = 0, offset=0, xmask = M, ymask = L;

  //Differences between the if/else statements:
  //x and y seem to be swapped
  /*
      IF:
   xc = x ^ ((y << M) >> L), yc = y;
   
   ELSE:
   xc = x, yc = y ^ ((x << L) >> M);
   
   */
  //This is the first step, the y and XOR of (x, y)
  //Except y and x swap roles if matrix is taller than it is wide(?)
  //Meaning, the nested FOR is the second two steps:
  //Reverse the bits and interleave the result
  /*
   Bit reversal and interleaving calculation:
   
   for (int bit=0; bit < M+L; ) {
     cellValue |= ((yc >> --ymask)&1) << bit++;
     for (offset += M; offset >= L; offset -= L) {
       cellValue |= ((xc >> --xmask)&1) << bit++;
     }
   }
   
   */

  //If matrix is wider than it is tall
  if (M==0 || (M > L && L != 0)) {
    //Step 1: Get x and xor(x, y)
    int xc = x ^ ((y << M) >> L), yc = y;
    //Bit reverse and interleave
    for (int bit=0; bit < M+L; ) {
      cellValue |= ((yc >> --ymask)&1) << bit++;
      for (offset += M; offset >= L; offset -= L) {
        cellValue |= ((xc >> --xmask)&1) << bit++;
      }
    }
  } else { //Else (If matrix is taller than it is wide)
    //Step 1: Get y and xor(y, x)
    int xc = x, yc = y ^ ((x << L) >> M);
    //Bit reverse and interleave
    for (int bit=0; bit < M+L; ) {
      cellValue |= ((xc >> --xmask)&1) << bit++;
      for (offset += L; offset >= M; offset -= M) {
        cellValue |= ((yc >> --ymask)&1) << bit++;
      }
    }
  }
  return cellValue;
}

void draw() {
  for (int x=0; x<size; x++) {
    for (int y=0; y<size; y++) {
      noStroke();
      int value = matrix[x][y];
      fill((value >> 16) & 0xFF, (value >> 8) & 0xFF, value & 0xFF);
      rect(x*16, y*16, 15, 15);
    }
  }
}

int[][] generateBayerMatrix(int size) {
  int[][] result = new int[size][size];
  for (int x=0; x<size; x++) {
    for (int y=0; y<size; y++) {
      result[x][y] = getBayerEntry(x, y, size);
    }
  }
  return result;
}

// < / sq(size) > may not be neccesary
int getBayerEntry(int x, int y, int size) {
  return int(bitReverse(bitInterleave(x^y, y)) / sq(size));
  //return bitReverse(bitInterleave(x^y, y));
}

//Translated into Java from C, source taken from stackoverflow.com/questions/746171
//Broken for certain inputs
//int bitReverse_low_memory(int bit) {
//  bit = (((bit & 0xaaaaaaaa) >> 1) | ((bit & 0x55555555) << 1));
//  bit = (((bit & 0xcccccccc) >> 2) | ((bit & 0x33333333) << 2));
//  bit = (((bit & 0xf0f0f0f0) >> 4) | ((bit & 0x0f0f0f0f) << 4));
//  bit = (((bit & 0xff00ff00) >> 8) | ((bit & 0x00ff00ff) << 8));
//  return ((bit >> 16) | (bit << 16));
//}
//
//Translated into Java from C, source taken from stackoverflow.com/questions/746171
//Broken for certain inputs
//int bitReverse_simple(int bit) {
//  int r = bit & 1; // r will be reversed bits of bit; first get LSB of bit
//  int s = 32; // extra shift needed at end
//
//  for (bit >>= 1; bit != 0; bit >>= 1) {   
//    r <<= 1;
//    r |= bit & 1;
//    s--;
//  }
//  return r <<= s;
//}

//Turns out Java comes prepackaged with a bit reversal function
int bitReverse(int bit) {
  return Integer.reverse(bit);
}

//Taken from stackoverflow.com/questions/3203764
//Broken for certain inputs
//int bitInterleave_old(int bit1, int bit2) {
//  int result = 0;
//  for (int i = 0; i < Integer.SIZE; i++) {
//    int bit1_masked_i = (bit1 & (1 << i));
//    int bit2_masked_i = (bit2 & (1 << i));
//
//    result |= (bit1_masked_i << i);
//    result |= (bit2_masked_i << (i + 1));
//  }
//  return result;
//}

//Own code, using algorithms given by en.wikipedia.org/wiki/Interleave_sequence
//Fully functional as per current testing
int bitInterleave(int bit1, int bit2) {
  String result = "";
  String binary1 = binary(bit1);
  String binary2 = binary(bit2);
  for (int i=0, len = binary1.length ()+binary2.length(); i<len; i++) {
    result += (i%2==0)?binary1.charAt(i/2):binary2.charAt((i-1)/2);
  }
  return unbinary(result);
}


boolean isPowerOfTwo(int x) {
  return (x!=0)&&((x&(x-1))==0);
}

float log2(float x) {
  return log(x)/log(2)+1e-10;
}

