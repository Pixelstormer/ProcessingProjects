class PictureMatch extends Minigame{
  private PictureTile[][] Tiles;
  private ArrayList<PImage> CardSprites;
  private PImage globalCoverSprite;
  private PVector globalCardSize;
  private PVector globalCardMargin;
  
  public PictureMatch(int wx, int wy, PImage gcs, PVector gCS, PVector t, PVector gCM, String d, String[] fn){
    super(wy,wy);
    this.globalCoverSprite = gcs;
    this.globalCardSize = gCS.get();
    this.globalCardMargin = gCM.get();
    this.CardSprites = new ArrayList<PImage>();
    loadCardSprites(d, fn);
    this.Tiles = new PictureTile[int(t.x)][int(t.y)];
    super.beginRun();
  }
  
  public void setup(){
    super.setup();
    constructTiles(new PVector(this.width/2,this.height/2),this.CardSprites);
  }
  
  public void draw(){
    background(0);
    
    reAlignTiles();
    renderTiles();
  }
  
  public void mousePressed(){
    i++;
    for(int x=0;x<this.Tiles.length;x++){
      for(int y=0;y<this.Tiles[x].length;y++){
        PVector loc = this.Tiles[x][y].GetLoc();
        if(this.mouseX<loc.x+this.globalCardSize.x/2 && this.mouseX>loc.x-this.globalCardSize.x/2 && this.mouseY<loc.y+this.globalCardSize.y/2  && this.mouseY>loc.y-this.globalCardSize.y/2){
          this.Tiles[x][y].Flip();
        }
      }
    }
  }
  
  private void loadCardSprites(String directory,String[] ForbiddenNames){
    String[] dataFolder = (new File(directory)).list();
    for(String s : dataFolder){
      String[] parsed = split(s,".");
      String fileName = "";
      for(int i=0;i<parsed.length-1;i++){
        fileName+=parsed[i];
      }
      String fileExtension = parsed[parsed.length-1];
      for(String S : ForbiddenNames){
        if(S.equals(s) || S.equals(fileName)){
          continue;
        }
      }
      if(fileExtension.equals("png") || fileExtension.equals("gif") || fileExtension.equals("jpg") || fileExtension.equals("tga")){
        CardSprites.add(loadImage(directory+"/"+s));
      }
    }
  }
  
  private void constructTiles(PVector o, ArrayList<PImage> pt){
    for(int x=0;x<this.Tiles.length;x++){
      for(int y=0;y<this.Tiles[x].length;y++){
        Tiles[x][y] = constructPictureTile(new PVector(o.x+(x-(this.Tiles.length-1)/2)*(this.globalCardSize.x+this.globalCardMargin.x),o.y+(y-(this.Tiles[x].length-1)/2)*(this.globalCardSize.y+this.globalCardMargin.y)),pt.get(floor(random(pt.size()-1))),false);
      }
    }
  }
  
  private void renderTiles(){
    for(int x=0;x<this.Tiles.length;x++){
      for(int y=0;y<this.Tiles[x].length;y++){
        Tiles[x][y].Render();
      }
    }
  }
  
  private void reAlignTiles(){
    for(int x=0;x<this.Tiles.length;x++){
      for(int y=0;y<this.Tiles[x].length;y++){
        Tiles[x][y].Move(new PVector(width/2+(x-(this.Tiles.length-0.9)/2)*(this.globalCardSize.x+this.globalCardMargin.x),height/2+(y-(this.Tiles[x].length-0.9)/2)*(this.globalCardSize.y+this.globalCardMargin.y)));
      }
    }
  }
  
  private PictureTile constructPictureTile(PVector l, PImage cs, boolean ss){
    return new PictureTile(l,this.globalCardSize.get(),cs,this.globalCoverSprite,ss);
  }
  
  private class PictureTile{
    private PVector location;
    private PVector size;
    private PImage cardSprite;
    private PImage coverSprite;
    private boolean isFlipped;
    
    public PictureTile(PVector l, PVector s, PImage cs, PImage cS, boolean ss){
      this.location = l.get();
      this.size = s.get();
      this.cardSprite = cs;
      this.coverSprite = cS;
      this.isFlipped = ss;
    }
    
    public void Render(){
      stroke(222);
      strokeWeight(4);
      fill(145,145,232);
      rectMode(CENTER);
      rect(this.location.x,this.location.y,this.size.x,this.size.y,45);
      imageMode(CENTER);
      image((this.isFlipped)?this.cardSprite:this.coverSprite,this.location.x,this.location.y,this.size.x/2,this.size.x/2);
    }
    
    public PVector GetLoc(){
      return this.location.get();
    }
    
    public void Flip(){
      this.isFlipped = !this.isFlipped;
    }
    
    public void Flip(boolean n){
      this.isFlipped = n;
    }
    
    public void Move(PVector n){
      this.location = n.get();
    }
    
    public void Offset(PVector o){
      this.location.add(o);
    }
  }
}


