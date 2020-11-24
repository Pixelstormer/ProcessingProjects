class InputSystem{
  private final HashMap<Integer, Boolean> heldKeys;
  
  InputSystem(int expectedInputs){
    heldKeys = new HashMap<Integer, Boolean>(expectedInputs);
  }
  
  InputSystem(){
    heldKeys = new HashMap<Integer, Boolean>();
  }
  
  void setKey(int input, boolean state){
    heldKeys.put(input, state);
  }
  
  void setKey(char input, boolean state){
    setKey(int(input), state);
  }
  
  void activateKey(int input){
    heldKeys.put(input, true);
  }
  
  void activateKey(char input){
    activateKey(int(input));
  }
  
  void deactivateKey(int input){
    heldKeys.put(input, false);
  }
  
  void deactivateKey(char input){
    deactivateKey(int(input));
  }
  
  boolean getKeyState(int input){
    return ((heldKeys.get(input)==null) ? false : heldKeys.get(input));
  }
  
  boolean getKeyState(char input){
    return getKeyState(int(input));
  }
}

