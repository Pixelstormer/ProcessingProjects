class Game {
  private ArrayList<GameObject> activeObjects;

  Game() {
    activeObjects = new ArrayList<GameObject>();
  }

  Game(ArrayList<GameObject> preInstantiatedObjects) {
    this();
    activeObjects.addAll(preInstantiatedObjects);
  }

  //Iterate game once
  void iterate() {
    background(0);
    for (GameObject go : activeObjects) {
      go.iterate();
    }
  }

  ArrayList<GameObject> activeObjects() {
    return activeObjects;
  }

  void addGameObject(GameObject go) {
    this.activeObjects.add(go);
  }

  GameObject getGameObject(int index) {
    if (index<0)return null;
    if (index>=activeObjects.size())return null;
    return this.activeObjects.get(index);
  }

  GameObject findClosestGameObject(PVector pointFrom) {
    GameObject closest = null;
    float closestDist = Float.MAX_VALUE;
    for (GameObject go : activeObjects()) {
      if (go instanceof GameObject) {
        float dist = PVector.dist(pointFrom, go.position());
        if (dist<closestDist) {
          closestDist = dist;
          closest = go;
        }
      }
    }
    return closest;
  }
  
  <T extends GameObject> T findClosestGameObjectOfType(PVector pointFrom, Class<T> classType){
    T closest = null;
    float closestDist = Float.MAX_VALUE;
    for (GameObject go : activeObjects()) {
      println(go.id);
      if (classType.isInstance(go)) {
        float dist = PVector.dist(pointFrom, go.position());
        if (dist<closestDist) {
          closestDist = dist;
          closest = (T)go;
        }
      }
    }
    return closest;
  }
  
  GameObject findById(String id){
    for(GameObject go : activeObjects()){
      if(go.id.equals(id))
        return go;
    }
    return null;
  }
  
  String generateId(){
    String s = "";
    for(int i=0; i<ID_LENGTH; i++){
      s += ALPHANUMERICS.charAt(ThreadLocalRandom.current().nextInt(ALPHANUMERICS.length()));
    }
    return s;
  }
}

