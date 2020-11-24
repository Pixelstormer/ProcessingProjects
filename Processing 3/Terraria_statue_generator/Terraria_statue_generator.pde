String Alphabet = "0123456789abcdefghijklmnopqrstuvwxyz ";
String output="";

String input = "omae wa mou shindeiru";

int[] indexes = new int[input.length()];

input = input.toLowerCase();

for(int i=0;i<input.length();i++){
  indexes[i]=Alphabet.indexOf(input.charAt(i));
}

for(int i : indexes){
  if(i==-1){
    output+="[i:52]";
  }
  else if(i==36){
    output+=' ';
  }
  else{
    output+="[i:"+(i+2702)+"]";
  }
}

println("Input: "+input);
println("Output: "+output);
exit();