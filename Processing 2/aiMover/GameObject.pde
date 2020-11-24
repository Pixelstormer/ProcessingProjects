interface GameObject{
  PVector position = new PVector(0,0);
  String displayName = "GAMEOBJECT";
  String id = null;
  void iterate();
  PVector position();
}

