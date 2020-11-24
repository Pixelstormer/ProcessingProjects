abstract class Surface extends TileComponent{
  //The base terrain upon which all other objects sit:
  //Dirt, rock, water, etc.
  protected Surface(Tile parent){
    super(parent);
    parent.terrain = this;
  }
  
}

