import java.util.HashMap;

class Alphabet{
  //Alphabet[c][x][y]
  //c is index of character
  //x is x
  static final HashMap<Character, Boolean[][]> alphabet = new HashMap<Character,Boolean[][]>(){{
    put('a',new Boolean[][]{
      {true,true,true},
      {true,false,true},
      {true,true,true},
      {true,false,true},
      {true,false,true}
    });
  }};
}