void setup(){
   StringBuilder builder = new StringBuilder("string");
   
   long builderStart = System.nanoTime();
   builder.append("appendedString");
   long builderEnd = System.nanoTime();
   
   println("Builder took: " + (builderEnd - builderStart));
   
   StringBuffer buffer = new StringBuffer("string");
   
   long bufferStart = System.nanoTime();
   buffer.append("appendedString");
   long bufferEnd = System.nanoTime();
   
   println("Buffer took: " + (bufferEnd - bufferStart));
   
   String string = "string";
   
   long stringStart = System.nanoTime();
   string += "appendedString";
   long stringEnd = System.nanoTime();
   
   println("String took: " + (stringEnd - stringStart));
   
   exit();
}

