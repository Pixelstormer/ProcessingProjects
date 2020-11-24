import java.util.List;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.Stack;
import java.util.ArrayList;
import java.util.Queue;
import java.util.Map.Entry;
import java.util.Iterator;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;

/*
┌─────────────────────────────────────┐
│ EXPERIMENTAL VERSION                │
│ attempting to include Serialization │
│ to allow saving created mindmaps    │
└─────────────────────────────────────┘
*/

//Factor by which to automatically scale the size of child nodes
final float CHILD_SIZE_SCALAR = .9;
//Factor by which to multiply the distance of child nodes from the edge of the parent node
final float CHILD_DIST_SCALAR = 1.5;
//Default size for newly created top-level nodes
final float DEFAULT_TOP_LEVEL_SIZE = 80;
//Default percentage by which all lerp-associated values use each iteration
final float GENERAL_LERP_AMT = .25;
//Amount by which to increase/decrease node size by
final float SIZE_CHANGE_AMT = 10;

//Angle from which the GUI nodes are aligned around the target node
final float GUI_NODE_ORIGIN_ANGLE = -45;
//Distance between target node and GUI node
final float GUI_NODE_DISTANCE = 35;
//Distance between each gui node
final float GUI_NODE_SEPERATION = 10;
//Default size for Gui Nodes
final float GUI_NODE_SIZE = 35;
//Angle between each gui node
final float GUI_NODE_ANGLE = GUI_NODE_SIZE/2 + GUI_NODE_SEPERATION;

final PVector POSITIVE_INDENT = new PVector(1, 1);
final PVector NEGATIVE_INDENT = new PVector(2, 2);

//Text briefly describing the the function of certain things
String hintText = "Press the Right Mouse Button to create a Node.";

//List of nodes that have no parent nodes
List<Node> topLevelNodes;

//For nodes that are currently animating deletion, and a time in milliseconds after which they'll be removed
HashMap<Node, Float> toRemove;

//List of currently active GuiNodes that the user can interact with
List<GuiNode> guiNodes;

//Observer controlled by user for direct tree manipulation
Observer userObserver;

void setup() {
  size(840, 560);
  frame.setResizable(true);

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  text("LOADING", width/2, height/2, 100, 100);

  topLevelNodes = new ArrayList<Node>(2);

  toRemove = new HashMap<Node, Float>(2);

   //- (c) Clean: Deletes all child nodes
   //- (c) Clear: Removes all text from this node and resets it to default size
   //- (h) Hue: Changes the hue (colour) of this node
   
  guiNodes = new ArrayList<GuiNode>(6);

  constructGuiNodes(guiNodes);
  alignGuiNodes(guiNodes);

  userObserver = new Observer();
}

void draw() {
  background(120);
  userObserver.setSpotlight(new PVector(mouseX, mouseY));

  performCollision(topLevelNodes);
  for (Node n : topLevelNodes) {
    n.deepUpdateLerps();
    n.deepRenderConnections();
    n.deepRender();
  }

  Iterator<Entry<Node, Float>> i = toRemove.entrySet().iterator();
  while (i.hasNext ()) {
    Entry<Node, Float> e = i.next();
    if (millis() > e.getValue()) {
      i.remove();
    } else {
      e.getKey().deepUpdateLerps();
      e.getKey().deepRender();
    }
  }

  for (GuiNode n : guiNodes) {
    n.deepUpdateLerps();
    n.updateLocation();
    n.constrainToBounds();
    n.updateTimer();
    if (n.isVisible()) n.deepRender();
  }

  renderHintText();
  
  fill(255);
  text(frameRate,25,25);
}

void constructGuiNodes(List<GuiNode> target) {
  addGuiNode(target, "ADD", "Adds a new Child Node to this node.", "addChildNode");
  addGuiNode(target, "REM", "Removes the newest child node from this node.", "removeChildNode");
  addGuiNode(target, "DEL", "Recursively deletes this node and all child nodes.", "deleteNode");
  addGuiNode(target, "ALIGN", "Attempts to recursively re-arrange this node's children to be evenly spaced around this node.", "realignNode");
  addGuiNode(target, "+SIZE", "Makes this node a bit bigger.", "addNodeSize");
  addGuiNode(target, "-SIZE", "Makes this node a bit smaller.", "subNodeSize");
}

void alignGuiNodes(List<GuiNode> target){
  int amt = target.size();
  float offset = amt/2 * GUI_NODE_ANGLE;
  float angle = GUI_NODE_ORIGIN_ANGLE - offset;
  for(GuiNode n : target){
    n.setAngle(angle);
    angle += GUI_NODE_ANGLE;
  }
}

void renderHintText() {
  fill(255);
  textSize(11);
  text(hintText, textWidth(hintText)/2+5, height - textAscent());
}

void performCollision(List<Node> toCollide) {
  if (toCollide.size()<=0) {
    return;
  }

  int aprox = toCollide.get(0).children().size() * toCollide.size();
  List<Node> linearList = new ArrayList<Node>(aprox);
  for (Node n : toCollide) {
    linearList.addAll(depthfirstCollectChildren(n));
  }

  while (linearList.size ()>0) {
    Node current = linearList.remove(0);
    for (Node n : linearList) {
      float dist = PVector.dist(current.location(), n.location());
      if (dist<current.actualSize()/2+n.actualSize()/2) {
        PVector displacement = (dist==0)?PVector.random2D():PVector.sub(n.location(), current.location());
        displacement.mult(GENERAL_LERP_AMT);
        n.offsetLocation(displacement);
        displacement.mult(-1);
        current.offsetLocation(displacement);
      }
    }

    current.constrainToBounds();
  }
}

void addToRemove(Node target) {
  toRemove.put(target, millis() + 200 * (target.getSize() / DEFAULT_TOP_LEVEL_SIZE));
}

ArrayList<Node> depthfirstCollectChildren(Node target) {
  ArrayList<Node> result = new ArrayList<Node>(target.children().size()+2);
  result.add(target);
  for (Node n : target.children ()) {
    result.addAll(depthfirstCollectChildren(n));
  }
  return result;
}

ArrayList<Node> breadfirstCollectChildren(Node target){
  ArrayList<Node> collected = new ArrayList<Node>(target.children().size()+2);
  Queue<Node> list = new LinkedList<Node>();
  list.add(target);

  while (!list.isEmpty ()) {
    Node next = list.poll();
    collected.add(next);
    if (next!=null) {
      list.addAll(next.children());
    }
  }
  
  return collected;
}

Method createMethodObject(String methodName, Object context, Class<?>... parameters) {
  Method result;
  try {
    result = context.getClass().getMethod(methodName, parameters);
  }
  catch(NoSuchMethodException e) {
    e.printStackTrace();
    throw new IllegalArgumentException(String.format("Could not find method of name '%s' in the context '%s' with the parameters '%s'.", methodName, context, parameters), e);
  }
  return result;
}

void ellipse(float x, float y, float size) {
  ellipse(x, y, size, size);
}

float getBestFontSize(float w, float h, String text) {
  boolean searching = true;
  float bestSize = 1;
  float currentSize = 1;
  while (searching) {
    if (testFontSize(currentSize, w, h, text)) {
      bestSize = currentSize;
      currentSize += 0.5;
    } else {
      searching = false;
    }
  }
  return bestSize;
}

boolean testFontSize(float s, float w, float h, String text) {
  textSize(s);
  // calculate max lines
  int currentLine = 1;
  int maxLines = floor( h / g.textLeading);
  boolean fitHeight = true;
  int nextWord = 0;
  String[] words = text.split(" ");

  while (fitHeight) {
    if (currentLine > maxLines) {
      fitHeight = false;
    } else {
      String temp = words[nextWord];
      // check if single word is already too wide
      if (textWidth(temp)>w)
        return false;

      boolean fitWidth = true;
      // add words until string is too wide  
      while (fitWidth) {

        if (textWidth(temp) > w) {
          currentLine++;
          fitWidth = false;
        } else {
          if (nextWord < words.length -1) {
            nextWord++;
            temp += " "+words[nextWord];
          } else
            return true;
        }
      }
    }
  }

  return false;
}

void updateHintText(String text){
  hintText = text;
}

void addGuiNode(List<GuiNode> target, String text, String hintText, String methodName){
  target.add((GuiNode)
    new GuiNodeBuilder()
    .setText(text)
    .setHintText(hintText)
    .setActualSize(GUI_NODE_SIZE)
    .setIgnoreParent(true)
    .registerActionContext(this)
    .registerNodeMethod(methodName)
    .build()
  );
}

void deleteNode(GuiNode caller, Node target) {
  userObserver.setSubject(null);
  userObserver.deselectGuiTarget();
  updateHintText("");
  if(topLevelNodes.remove(target)){
    addToRemove(target);
    target.deepDeleteChildren();
    return;
  }
  
  for (Node n : topLevelNodes) {
    n.deepDeleteChild(target);
  }
}

void addChildNode(GuiNode caller, Node target){
  if (target == null) return;
  target.addChildren(1);
}

void removeChildNode(GuiNode caller, Node target){
  if (target == null) return;
  target.deleteFromIndex(target.children().size()-1);
}

void realignNode(GuiNode caller, Node target) {
  if (target == null) return;
  target.realignChildren();
}

void addNodeSize(GuiNode caller, Node target){
  if (target == null) return;
  target.addSize(SIZE_CHANGE_AMT);
}

void subNodeSize(GuiNode caller, Node target){
  if (target == null) return;
  target.reduceSize(SIZE_CHANGE_AMT);
}

void mousePressed() {
  switch(mouseButton) {
  case LEFT:

    Node targeted = userObserver.getColliding(topLevelNodes);
    if (targeted == userObserver.getSubject()) userObserver.beginInteracting();
    break;
  }
}

void mouseReleased() {
  switch(mouseButton) {
  case LEFT:
    //Selecting / Deselecting nodes
    
    userObserver.stopInteracting();
    Node newSubject = userObserver.getColliding(topLevelNodes);
    
    if(userObserver.hasGuiTarget()){
      userObserver.invokeGuiTarget();
    }
    else{
      if(newSubject != userObserver.getSubject()){
        userObserver.setSubject(newSubject);
        if(userObserver.hasSelected()){
          for (GuiNode n : guiNodes) {
            n.setToAppearFrom(newSubject);
            n.setVisible(true);
          }
        }
      }
    }
    break;
  case RIGHT:
    //Creating new nodes
    if (!userObserver.hasSelected()) {
      updateHintText("");
      topLevelNodes.add(
      new NodeBuilder()
        .setLocation(userObserver.getSpotlight())
        .setRenderLocation(userObserver.getSpotlight())
        .setActualSize(DEFAULT_TOP_LEVEL_SIZE)
        .setSize(SIZE_CHANGE_AMT)
        .setAngle(90)
        .setIgnoreParent(true)
        .build()
        );
    } else {
      userObserver.getSubject().addChildren(1);
    }
    break;
  }
}

void keyPressed() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case LEFT:

      break;
    case RIGHT:

      break;
    }
    break;
  case BACKSPACE:
    if (userObserver.hasSelected()) {
      if (userObserver.getSubject().getText().length()>0) {
        userObserver.getSubject().popChar();
      }
    }
    break;
  case TAB:

    break;
  case ENTER:
  case RETURN:
    if (userObserver.hasSelected()) {
      userObserver.getSubject().appendChar('\n');
    }
    break;
  case ESC:
    exit();
    break;
  case DELETE:
    if(userObserver.hasSelected()){
      deleteNode(null,userObserver.getSubject());
    }
    break;
  default:
    if (userObserver.hasSelected()) {
      userObserver.getSubject().appendChar(key);
    }
    break;
  }
}

void mouseDragged() {
  if (userObserver.hasSelected() && userObserver.isInteracting()) {
    PVector dir = PVector.sub(userObserver.getSpotlight(), userObserver.getSubject().location());
    dir.mult(GENERAL_LERP_AMT);
    userObserver.getSubject().offsetLocation(dir);
  }
}

void mouseMoved() {
  if (userObserver.hasSelected()) userObserver.updateGuiNodeCollision();
}

