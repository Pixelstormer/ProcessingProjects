//An extended version of Console that aims to include the ability to send and recieve messages from other instances of this sketch through network capabilities.

import processing.net.*;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.MissingFormatArgumentException;
import java.util.Arrays;
import java.net.ConnectException;
import java.net.BindException;
import java.net.UnknownHostException;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;

//----------------------------------//
//-- Clientside text and commands --//
//----------------------------------//

//Posted text
ArrayList<String> Text;
//Input text
String BufferedText;

//Name of Intro Message file
final String IntroMessageFile = "IntroMessage.txt";
//Maximum length for message that is automatically posted when program is started
int maximumIntroMessageLength;

//Name of Simple Response file
final String SimpleResponseFile = "SimpleResponses.txt";
//Maximum number of simple responses that can be loaded at once
int maximumSimpleResponses;
//Store for all loaded simpleresponses
StringDict simpleResponses;

//Name of help response file
final String HelpResponseFile = "HelpResponses.txt";
//Maximum number of help responses that can be loaded at once
int maximumHelpResponses;
//Store for all loaded helpresponses
StringDict helpResponses;

//Name of aliases file
final String AliasesFile = "CommandAliases.txt";
//Maximum number of aliases for a given command
int maximumAliases;
//Aliases for commands
//Key is the 'base' command used by the program itself to look-up commands
//Value is an arraylist of all aliases for a given 'base' command
HashMap<String, ArrayList<String>> Aliases;

//Font
PFont TextFont;

//Blank space betweean each posted line
float distanceBetweenLines;
//Blank space between each character on each line
float distanceBetweenChars;

//Size of the tab character
int spacesInTab;
//Artifical tab character
String tabCharacter;

//Distance between edge of text and top and left edges of screen
PVector positiveIndent;
//Distance between edge of text and bottom and right edges of screen
PVector negativeIndent;
//Distance between input text box border and left and right edges of screen
PVector horizontalIndent;
//Distance between input text box border and top and bottom of text
PVector verticalIndent;

//How far posted text has overflowed past the height of the screen
float overflow;

//Time since text line last flashed
float textPointTimer;
//Text line flashes every this many milliseconds
float textPointInterval;
//State of the text line
boolean textPointShowing;
//Position of the text line
int textPointIndex;

//-------------------//
//-- Network stuff --//
//-------------------//

//Currently active client
Client CurrentClient;
//Currently active server
Server CurrentServer;
//List of clients connected to the active server, and their given usernames
HashMap<Client, String> HostedClients;
//Non-persistent network username
String Username;
//Custom name for currently active server, either being hosted here or connected to
String Servername;
//If the program expects there to be some form of connection currently active
boolean ConnectionExpected;
//IP that client is currently connected to
String IP;
//Port that client is currently connected to
int Port;

//As server: Chat message distributed to all clients
//As client: Chat message recieved directly from server
final byte SERVER_MSG = 8;
//As server: Chat message recieved from a client
//As client: Chat message server recieved from a client, that is re-distributed to other clients
final byte CLIENT_MSG = 9;
//As server: Message recieved from client when said client joins, contains their username
//As client: Message recieved from server informing of a new client who joined
final byte JOIN_MSG = 10;
//As server: Message recieved from client when said client voluntarily leaves
//As client: Message recieved from server when server is closing
final byte LEAVE_MSG = 11;
//As server: Message distributed to clients to indicate a client has been manually kicked
//As client: Message recieved from server to indicate a client has been manually kicked
final byte KICK_MSG = 12;
//As server: Message recieved from client when said client changes their username, to indicate their (new) username
//As client: Message recieved from server when connected to indicate the server name
final byte NAME_MSG = 13;
//As server: Message sent to clients when they join to inform them of all other connected clients
//As client: Message receieved from server indicating it is a list of the usernames of all other connected clients
final byte ONLINE_MSG = 14;
//Byte used to seperate entries in a list message.
final byte LIST_SEP_CHAR = 127;
//Indicates the end of a message
final byte MSG_END_CHAR = 0;

void setup() {
  size(840, 560);
  frame.setResizable(true);

  Load();
}

void Load() {
  InitVariables();
  loadSimpleResponses();
  loadHelpResponses();
  loadAliases();
  loadIntroMessage();
}

void InitVariables() {
  Text = new ArrayList<String>();
  BufferedText = "";

  maximumIntroMessageLength = 2000;
  maximumSimpleResponses = 2000;
  maximumHelpResponses = 2000;
  maximumAliases = 2000;

  simpleResponses = new StringDict();

  helpResponses = new StringDict();

  Aliases = new HashMap<String, ArrayList<String>>();

  distanceBetweenLines = 2;
  distanceBetweenChars = 1;

  spacesInTab = 4;
  tabCharacter="";
  for (int i=0; i<spacesInTab; i++) {
    tabCharacter+=' ';
  }

  positiveIndent = new PVector(15, 15);
  negativeIndent = new PVector(15, 15);
  horizontalIndent = new PVector(1, 1);
  verticalIndent = new PVector(2, 2);

  overflow = 0;

  textPointTimer = millis();
  textPointInterval = 800;
  textPointShowing = false;
  textPointIndex = 0;

  TextFont = loadFont("CourierNoSmooth.vlw");
  textAlign(LEFT, TOP);
  textFont(TextFont, g.textSize);
  noSmooth();
  background(0);

  Username = Server.ip();
  Servername = null;
  ConnectionExpected = false;
}

void draw() {
  background(0);

  doNetListening();

  if (millis()-textPointTimer > textPointInterval) {
    resetTextPoint();
  }

  renderBufferedText(renderSubmittedText());
}

synchronized float renderSubmittedText() {
  float y = positiveIndent.y - overflow;
  for (String s : Text) {
    float x = positiveIndent.x;
    for (int i=0; i<s.length (); i++) {
      char c = s.charAt(i);
      if (c == '\n') {
        x=positiveIndent.x;
        y+=distanceBetweenLines+textAscent()+textDescent();
        continue;
      }
      if (y>-(textAscent()+textDescent())) {
        fill(255);
        text(c, x, y);
      }
      x+=distanceBetweenChars+textWidth(c);
      if (x>width-negativeIndent.x) {
        x=positiveIndent.x+textWidth(tabCharacter);
        y+=distanceBetweenLines+textAscent()+textDescent();
      }
    }
    y+=distanceBetweenLines+textAscent()+textDescent();
    if (y>height-negativeIndent.y) {
      overflow+=textAscent()+textDescent();
    }
  }
  return y;
}

synchronized void renderBufferedText(float y) {
  y = constrain(y, positiveIndent.y, height-negativeIndent.y);
  float x = positiveIndent.x;
  float pointX = -1;
  text("> ", x, y);
  x+=distanceBetweenChars+textWidth("> ");
  for (int i=0; i<BufferedText.length (); i++) {
    char c = BufferedText.charAt(i);
    //    if (c == '\t') {
    //      x+=textWidth(tabCharacter);
    //    }
    fill(255);
    text(c, x, y);
    if (i==textPointIndex) {
      pointX = x;
      renderTextPoint(x, y); //' '
    }
    x+=distanceBetweenChars+textWidth(c);
  }

  if (pointX == -1) {
    renderTextPoint(x, y);
  }

  noFill();
  stroke(255);
  rect(horizontalIndent.x, y-verticalIndent.x, width-(horizontalIndent.y+2), textAscent()+textDescent()+verticalIndent.y);
}

void invokeTextResponse(String text) {
  //Parse given text input and invoke methods with it
  try {
    printI(text);

    //If it is blank, simply return
    if (text.equals("")) {
      return;
    }

    //First handle simpleresponses
    if (simpleResponses.get(text) != null) {
      printT(simpleResponses.get(text));
      return;
    }

    //Parse the input text to extract the command name and given arguments
    String[] semiparsed = text.split(" ");
    String methodName = semiparsed[0];
    String[] arguments = new String[] {
    };
    if (semiparsed.length>1) {
      arguments = Arrays.copyOfRange(semiparsed, 1, semiparsed.length);
    }

    //Creating method object
    Method command;

    //If it is not a recognised alias, check if it does not have any aliases.
    if (getBaseCommandName(methodName) == null) {
      try {
        command = getClass().getMethod(methodName, String[].class);
      }
      catch(NoSuchMethodException e) {
        throw new IllegalArgumentException("Command \""+methodName+"\" is not a valid command or is not a valid alias.");
      }
    } else {
      try {
        command = getClass().getMethod(getBaseCommandName(methodName), String[].class);
      }
      catch(NullPointerException e) {
        //Still check for null in case something happens which causes the initial null check to not work
        //If alias is invalid getBaseCommandName returns null
        throw new IllegalArgumentException("Command \""+text+"\" is not valid or is not a valid alias.");
      }
    }

    try {
      //Invoke it with arguments
      command.invoke(this, (Object)arguments);
    }
    catch(InvocationTargetException e) {
      throw (Exception)e.getCause();
    }
  }
  catch(Exception e) {
    printException(e);
  }
}

//-------------------------//
//---- Command methods ----//
//-------------------------//

//All command methods return void and take a String[] as their single argument
//They are generally in the format:
/*
void commandName(String[] args){
 //This is what this command does
 if(<given arguments are invalid>){
 throw new IllegalArgumentException(<Why the given arguments are invalid>);
 }
 <What the command does>
 }
 */

//-- No argument methods --//
//These methods do not take any arguments, and so throw exceptions if they are given any arguments.

void clear(String[] args) {
  //Clears the screen
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  Text.clear();
  overflow = 0;
}

void motd(String[] args) {
  //Prints the motd
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  loadIntroMessage();
}

void loadsr(String args[]) {
  //Reloads simple responses
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  printT("Loaded "+loadSimpleResponses()+" simpleresonses.");
}

void getsr(String[] args) {
  //Prints all loaded simple responses
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  for (String Key : simpleResponses.keys ()) {
    String Response = simpleResponses.get(Key);
    printT(Key+": "+Response);
  }
}

void loadh(String[] args) {
  //Reloads help responses
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  printT("Loaded "+loadHelpResponses()+" helpresponses.");
}

void loada(String[] args) {
  //Reloads command aliases
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  printT("Loaded "+loadAliases()+" command aliases.");
}

void date(String[] args) {
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  //Prints the current date and time according to the system clock
  printT(hour()+":"+minute()+", "+day()+"/"+month()+"/"+year());
}

void getip(String[] args) {
  //Prints this machine's IP address, from a number of perspectives that this program has.
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  printT("Server IP: "+Server.ip());
  try {
    printT(tabCharacter+"ClientIP: "+CurrentClient.ip());
  }
  catch(NullPointerException e) {
    printT(tabCharacter+"ClientIP: null");
  }
  printT("Stored IP: "+IP);
}

void getu(String[] args) {
  //Returns the current username
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  printT("Current username: \""+Username+"\"");
}

void gets(String[] args) {
  //Returns the current server name
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  printT("Current server name: \""+((Servername==null)?"null":Servername)+"\"");
}

void geto(String[] args) throws ConnectException {
  //Requests to see the list of currently connected clients from the server
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  if (!ConnectionExpected) {
    throw new ConnectException("Cannot see clients connected to a connection that does not exist.");
  }
  if (CurrentClient!=null) {
    CurrentClient.write(char(ONLINE_MSG)+" "+char(MSG_END_CHAR));
    printT("Requested online clients from server:");
  } else if (CurrentServer!=null) {
    printT("Currently visible connected clients:");
    for (Client c : HostedClients.keySet ()) {
      String name = HostedClients.get(c);
      printT("Client \""+c+"\": \""+name+"\"");
    }
  }
}

void cstat(String[] args) {
  //Returns a large amount of information about the current connection, if any
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  printT("Connection status:");
  printT(tabCharacter+"ConnectionExpected: "+ConnectionExpected);
  printT(tabCharacter+"Connection type: "+((CurrentServer==null)?((CurrentClient==null)?"NONE":"CLIENT"):"SERVER"));
  printT(tabCharacter+"CurrentServer: "+CurrentServer);
  printT(tabCharacter+"CurrentClient: "+CurrentClient);
  printT(tabCharacter+"Stored clients: ");
  if (HostedClients==null) {
    printT(tabCharacter+tabCharacter+"None");
  } else {
    for (Client c : HostedClients.keySet ()) {
      printT(tabCharacter+tabCharacter+c+": \""+HostedClients.get(c)+"\"");
    }
  }
  printT(tabCharacter+"Username: "+Username);
  printT(tabCharacter+"Servername: "+Servername);
  try {
    printT(tabCharacter+"ClientIP: "+CurrentClient.ip());
  }
  catch(NullPointerException e) {
    printT(tabCharacter+"ClientIP: null");
  }
  printT(tabCharacter+"ServerIP: "+CurrentServer.ip());
  printT(tabCharacter+"Stored IP: "+IP);
  printT(tabCharacter+"Stored Port: "+Port);
}

void disc(String[] args) {
  //Severs the current connection. Throws an exception if there is none
  if (args.length>0) {
    throwIllegalArgumentException("zero arguments", args.length);
  }
  if (CurrentClient != null) {
    CurrentClient.clear();
    CurrentClient.write(char(LEAVE_MSG)+"Placeholder message"+char(MSG_END_CHAR));
    CurrentClient.stop();
    CurrentClient = null;
    ConnectionExpected = false;
    Servername = null;
    printT("Disconnected from server at IP \""+IP+"\" on port \""+Port+"\": \"Connection closed by client\"");
    IP = null;
    Port = -1;
    return;
  }
  if (CurrentServer != null) {
    CurrentServer.write(char(LEAVE_MSG)+"You shouldn't be reading this."+char(MSG_END_CHAR));
    CurrentServer.stop();
    CurrentServer = null;
    ConnectionExpected = false;
    Servername = null;
    HostedClients.clear();
    HostedClients = null;
    printT("Successfully stopped server at IP \""+IP+"\" on port \""+Port+"\".");
    return;
  }
  throw new IllegalArgumentException("Cannot disconnect from a connection that does not exist.");
}

//-- Single argument commands --//
//These commands take exactly 1 argument, and so throw an exception if given 0 or 2+ arguments.

void help(String[] args) {
  //Takes exactly 0 or 1 argument.
  //0 arguments: Prints help for every command
  //1 argument: Prints help for the given command
  //Throws exception if given number of arguments is not 0 or 1
  switch(args.length) {
  case 0:
    for (String Key : helpResponses.keys ()) {
      String Response = helpResponses.get(Key);
      printT(Key+": "+Response);
    }
    return;
  case 1:
    String base = getBaseCommandName(args[0]);
    if (base==null && !(helpResponses.hasKey(args[0])))
      //If it is not an alias and does not have a help entry, throw an exception
      throw new IllegalArgumentException("Command \""+args[0]+"\" is not a valid alias or does not have a valid help entry.");
    

    //If it has a help entry itself, no need to check for aliases
    if (helpResponses.hasKey(args[0])) {
      printT(args[0]+": "+helpResponses.get(args[0]));
      return;
    }

    //If it is an alias, print help for the base
    if (helpResponses.hasKey(base)) {
      printT("Command \""+args[0]+"\" is an alias for command \""+base+"\". Showing help for command \""+base+"\"...");
      printT(base+": "+helpResponses.get(base));
    }
    return;
  default:
    throwIllegalArgumentNumberException("exactly 0 or exactly 1 argument", args.length);
    break;
  }
}

void echo(String[] args) {
  if (args.length<1) 
    throwIllegalArgumentNumberException("Exactly 1 unterminated argument", args.length);
  
  printT(collapseStringArray(args, " ", 0, args.length));
}

void addsr(String[] args) {
  if (args.length!=1) 
    throwIllegalArgumentNumberException("exactly 1 argument", args.length);
  
  addSimpleResponse(args[0]);
}

void addh(String[] args) {
  if (args.length<1) 
    throwIllegalArgumentNumberException("exactly 1 unterminated argument", args.length);
  
  addHelpResponse(collapseStringArray(args, " ", 0, args.length));
}

void adda(String[] args) {
  if (args.length!=1) 
    throwIllegalArgumentNumberException("exactly 1 argument", args.length);
  
  addAlias(args[0]);
}

void geta(String[] args) {
  if (args.length!=1) 
    throwIllegalArgumentNumberException("exactly 1 argument", args.length);
  
  String base = getBaseCommandName(args[0]);
  if (base==null) {
    printT("Command \""+args[0]+"\" has no loaded aliases, or is an invalid command.");
    return;
  }
  if (!args[0].equals(base)) 
    printT("Command \""+args[0]+"\" is an alias for command \""+base+"\".");
  
  printT("Aliases for command \""+base+"\":");
  if (Aliases.containsKey(base)) {
    for (String s : Aliases.get (base)) {
      printT(tabCharacter+s);
    }
  } else {
    printT("Command \""+args[0]+"\" has no loaded aliases, or is an invalid command.");
  }
}

void getb(String[] args) {
  //Gets the 'base' command for an alias
  if (args.length!=1) 
    throwIllegalArgumentNumberException("exactly 1 argument", args.length);
  
  String base = getBaseCommandName(args[0]);
  if (base==null) {
    printT("Command \""+args[0]+"\" is an invalid alias, or is a command that does not have any aliases.");
    return;
  }
  printT("Base command for alias \""+args[0]+"\": "+base);
}

void rema(String[] args) {
  if (args.length!=1) 
    throwIllegalArgumentNumberException("exactly 1 argument", args.length);
  
  printT("Removes a command alias. Non-functional.");
}

void remsr(String[] args) {
  if (args.length!=1) 
    throwIllegalArgumentNumberException("exactly 1 argument", args.length);
  
  printT("Removes a simple response. Non-functional command");
}

void remh(String[] args) {
  if (args.length!=1) 
    throwIllegalArgumentNumberException("exactly 1 argument", args.length);
  
  printT("Removes a help entry. Non-functional command");
}

void setu(String[] args) {
  if (args.length<1) 
    throwIllegalArgumentNumberException("exactly 1 unterminated argument", args.length);
  
  String New = collapseStringArray(args, " ", 0, args.length);
  if (New.indexOf(":")!=-1) 
    throw new IllegalArgumentException("Cannot have character \":\" in your username as several commands use this character to indicate a special purpose.");
  
  Username = New;
  if (CurrentClient!=null) 
    CurrentClient.write(char(NAME_MSG)+Username+char(MSG_END_CHAR));
  
  printT("Set username to \""+Username+"\".");
}

void msg(String[] args) throws ConnectException {
  if (args.length<1) 
    throwIllegalArgumentNumberException("exactly 1 unterminated argument", args.length);
  
  //Both currentserver and currentclient not being null at the same time should be impossible
  if (CurrentServer != null && CurrentClient != null) {
    disc(new String[] {
    }
    );
    throw new IllegalStateException("It is impossible to have both a client and a server connection active at the same time. All connections have been terminated.");
  }
  if (CurrentServer == null) {
    if (CurrentClient == null) {
      //Both null - raise exception
      throw new ConnectException("Cannot write a message to a connection that does not exist.");
    } else { 
      //Server null but not client - Client message
      CurrentClient.write(char(CLIENT_MSG)+collapseStringArray(args, " ", 0, args.length)+char(MSG_END_CHAR));
    }
  } else {
    //Server not null - server message
    printT("(Server) "+Username+": "+collapseStringArray(args, " ", 0, args.length));
    CurrentServer.write(char(SERVER_MSG)+Username+": "+collapseStringArray(args, " ", 0, args.length)+char(MSG_END_CHAR));
  }
}

//-- Multiple argument commands --//
//These commands take more than 1 argument, and throw an exception if the number of arguments given is different to what they expect.

void host(String[] args) throws BindException {
  //Creates a new server which clients can connect to
  if (args.length<2) 
    throwIllegalArgumentNumberException("exactly 1 normal argument AND exactly 1 unterminated argument", args.length);
  
  if (ConnectionExpected) 
    //If already connected to something, we cannot create a new connection. User must manually stop current connection first.
    throw new BindException("A connection is already in use - Close this connection before attempting to create a new one.");
  
  IP = Server.ip();
  Port = int(args[0]);
  Servername = collapseStringArray(args, " ", 1, args.length);
  thread("connectServer");
}

void con(String[] args) throws BindException {
  //Creates a client and attempts to connect it to a server
  if (args.length!=2) 
    throwIllegalArgumentNumberException("exactly 2 arguments", args.length);
  
  if (ConnectionExpected) 
    //If already connected to something, we cannot create a new connection. User must manually stop current connection first.
    throw new BindException("A connection is already in use - Close this connection before attempting to create a new one.");
  
  IP = args[0];
  Port = int(args[1]);
  Servername = null;
  thread("connectClient");
}

void kick(String[] args) throws Exception {
  //When you are hosting a server, kicks a client that is connected to your server via their username
  if (args.length<1) 
    throwIllegalArgumentNumberException("exactly 1 argument", args.length);
  
  String expression = collapseStringArray(args, " ", 0, args.length);
  if (CurrentServer==null) {
    if (CurrentClient==null) {
      throw new ConnectException("Cannot kick clients off a connection that does not exist.");
    } else {
      throw new ConnectException("Cannot kick clients off a connection when you are a client.");
    }
  }
  if (HostedClients == null) 
    throw new ConnectException("Cannot kick clients off a connection that does not exist.");
  
  if (expression.indexOf(":")==-1||expression.indexOf(":")==trim(expression).length()-1) {
    performKick(expression, "No reason given.");
    return;
  }
  GenericStringParse(expression, "kick message", ':', "performKick");
}

void exit(String[] args) {
  if (args.length != 0) throwIllegalArgumentNumberException("zero arguments", args.length);
  try{
    disc(new String[]{});
  }
  catch(IllegalArgumentException e){}
  exit();
}

void throwIllegalArgumentNumberException(String correct, int given) throws IllegalArgumentException {
  throwIllegalArgumentException(correct, given);
}

void throwIllegalArgumentException(String correct, int given) throws IllegalArgumentException {
  throw new IllegalArgumentException("This command takes "+correct+", but was given an illegal number ("+given+") of arguments.");
}

//------------------------------//
//---- Command methods ends ----//
//------------------------------//

synchronized void printI(String input) {
  Text.add("> "+input);
}

synchronized void printR(String input, String response) {
  Text.add("> "+input);
  Text.add(response);
}

synchronized void printT(String text) {
  Text.add(text);
}

void resetTextPoint() {
  textPointTimer = millis();
  textPointShowing = !textPointShowing;
}

void resetTextPoint(boolean value) {
  textPointTimer = millis();
  textPointShowing = value;
}

void renderTextPoint(float x, float y) {
  if (textPointShowing) {
    stroke(255);
  } else {
    noStroke();
  }
  line(x-1, y-2, x-1, y+textAscent()+textDescent());
}

String getBaseCommandName(String alias) {
  //Returns the base command name for a given alias, or null if there is none

  //If the given alias is one of the base commands, that is that base command
  if (Aliases.containsKey(alias)) {
    return alias;
  } else {
    //Otherwise, search for aliases
    //For every base command,
    for (String base : Aliases.keySet ()) {
      //For every aliase for that command,
      for (String a : Aliases.get (base)) {
        //If the given alias is equal,
        if (alias.equals(a)) {
          //This base is what we're looking for
          return base;
        }
      }
    }
  }
  //If nothing has been returned by now, there is no alias, so return null
  return null;
}

int loadIntroMessage() {
  try {
    return GenericFileLoad(IntroMessageFile, maximumIntroMessageLength, "Intro Message Lines", "printT");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
  return 0;
}

int loadSimpleResponses() {
  try {
    return GenericFileLoad(SimpleResponseFile, maximumSimpleResponses, "SimpleResponse", "loadSimpleResponse");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
  return 0;
}

void addSimpleResponse(String line) {
  try {
    GenericFileWrite(SimpleResponseFile, line, "SimpleResponse", "loadSimpleResponse");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
}

void loadSimpleResponse(String raw) {
  try {
    GenericStringParse(raw, "SimpleResponse", ':', "setParsedSR");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
}

void setParsedSR(String keyword, String response) {
  simpleResponses.set(keyword, response);
}

int loadHelpResponses() {
  try {
    return GenericFileLoad(HelpResponseFile, maximumHelpResponses, "Help Entry", "loadHelpResponse");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
  return 0;
}

void addHelpResponse(String line) {
  try {
    GenericFileWrite(HelpResponseFile, line, "Help Entry", "loadHelpResponse");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
}

void loadHelpResponse(String raw) {
  try {
    GenericStringParse(raw, "Help Entry", ':', "setParsedHR");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
}

void setParsedHR(String keyword, String response) {
  helpResponses.set(keyword, response);
}

int loadAliases() {
  try {
    return GenericFileLoad(AliasesFile, maximumAliases, "Command Alias", "loadAlias");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
  return 0;
}

void addAlias(String line) {
  try {
    GenericFileWrite(AliasesFile, line, "Command Alias", "loadAlias");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
}

void loadAlias(String raw) {
  try {
    GenericStringParse(raw, "Command Alias", ':', "setSemiParsedAlias");
  }
  catch(Exception e) {
    //InvocationTargetException wraps a Throwable, but these methods cast it as an Exception.
    printException(e);
  }
}

void setSemiParsedAlias(String base, String aliases) {
  String[] parsedAliases = aliases.split(",");
  //If Aliases does contain base, check for duplicate entries and add the new aliases
  if (Aliases.containsKey(base)) {
    //For each new alias,
n:
    for (String New : parsedAliases) {
      //Check it against each old alias,
o:
      for (String Old : Aliases.get (base)) {
        if (New.equals(Old)) {
          //If the new alias is already present, skip it
          continue n;
        }
      }
      //If this new alias has not been skipped, add it
      Aliases.get(base).add(New);
    }
  } else {
    //If Aliases does not contain base, create a new entry and add the new aliases
    //Convert Array[] to ArrayList<>
    Aliases.put(base, new ArrayList<String>(Arrays.asList(parsedAliases)));
  }
}

boolean checkAlias(String base, String command) {
  //Checks if 'command' is a valid alias for 'base'
  if (command.equals(base)) {
    //If they the alias is the same as the base command, return true
    return true;
  } else {
    //Else, check the loaded aliases for the base command and compare them to the given command
    if (Aliases.containsKey(base)) {
      for (String s : Aliases.get (base)) {
        if (s.equals(command)) {
          return true;
        }
      }
    }
  }
  //If nothing has been found by now, command is not a valid alias for base, so return false
  return false;
}

void GenericStringParse(String line, String keyWord, char Seperator, String LoadMethodName) throws Exception {
  //General function for parsing a string into two halves with a seperator character, and calling a method on each half
  Method LoadMethod = getClass().getMethod(LoadMethodName, new Class[] {
    String.class, String.class
  }
  );
  if (line != null && !line.equals("")) {
    try {
      //All (Seperator) characters in the primary half must be prepended with a \
      int splitIndex = -1;
      boolean toEscape = false;
      int len = line.length();
      for (int i=0; i<len; i++) {
        char c = line.charAt(i);

        if (toEscape) {
          //If this character is part of an escape sequence dont parse it normally
          toEscape = false;
          switch(c) {
            //Reconstruct string replacing target escape sequence with proper character
          case 't':
            //Tab character
            line = replaceCharacters(line, tabCharacter, i-1, i);
            break;
          case 'n':
            //New line
            line = replaceCharacters(line, '\n', i-1, i);
            break;
          }
          //Two escape sequence characters are replaced with one parsed character so move back by one character to compensate
          i--;
        } else {
          try {
            if (c == Seperator && splitIndex==-1 && line.charAt(i-1) != '\\') {
              splitIndex = i;
              if (i==line.length()-1) {
                throw new IOException("Cannot have empty response in "+keyWord+" \""+line+"\". This "+keyWord+" will not be loaded.");
              }
            }
          }
          catch(StringIndexOutOfBoundsException e) {
            throw new IOException("Cannot have empty keyword in "+keyWord+" \""+line+"\". This "+keyWord+" will not be loaded.");
          }

          //If there is a backslash and this backslash is not escaping another backslash and is not being escaped by another backslash...
          if (c == '\\' && !(i>0 && line.charAt(i-1) == '\\') && !(i<line.length()-1 && line.charAt(i+1) == '\\')) {
            //...The next character is going to be part of an escape sequence
            toEscape = true;
          }
        }
        len = line.length();
      }
      if (splitIndex == -1) {
        throw new IOException("Invalid format for "+keyWord+" \""+line+"\" - This "+keyWord+" does not appear to have a correct seperator character (\""+Seperator+"\"). This "+keyWord+" will not be loaded.");
      }
      try {
        String Primary = line.substring(0, splitIndex);
        String Secondary = line.substring(splitIndex+1);
        LoadMethod.invoke(this, new Object[] {
          Primary, Secondary
        }
        );
      }
      catch(InvocationTargetException e) {
        throw (Exception)e.getCause();
      }
    }
    catch(IOException e) {
      printException(e);
      printT("An error has occurred while attempting to load "+keyWord+" \""+line+"\". This "+keyWord+" will not be loaded. See the above stack trace for details.");
    }
  }
}

int GenericFileLoad(String fileName, int maxLines, String surpassedKeyword, String LoadMethodName) throws Exception {
  //General function for loading a text file and calling a given function on each line.
  BufferedReader FileReader = createReader(fileName);
  String line = "";
  int lineCount = 0;
  //Construct the Method object that associates with the Method that will be called on each line
  Method LoadMethod = getClass().getMethod(LoadMethodName, String.class);
  while (line != null && lineCount<maxLines) {
    try {
      line = FileReader.readLine();
    }
    catch(IOException e) {
      printException(e);
      line = null;
    }
    if (line==null) {
      break;
    }
    //Invoke the given method with the current line as the argument
    try {
      LoadMethod.invoke(this, line);
    }
    catch(InvocationTargetException e) {
      throw (Exception)e.getCause();
    }
    if (!trim(line).equals("")) {
      lineCount++;
    }
  }
  if (lineCount>=maxLines) {
    printT("The maximum number of "+surpassedKeyword+"s has been surpassed. Only the "+surpassedKeyword+" up to \""+line+"\" have been loaded.");
  }
  try {
    FileReader.close();
  }
  catch(IOException e) {
    printException(e);
  }
  return lineCount;
}

void GenericFileWrite(String fileName, String line, String keyWord, String loadMethodName) throws Exception {
  //General function for calling a function on a string and writing that string to a file
  PrintWriter out = null;
  Method LoadMethod = getClass().getMethod(loadMethodName, String.class);
  try {
    LoadMethod.invoke(this, line);
    String path = dataPath(fileName);
    out = new PrintWriter(new BufferedWriter(new FileWriter(path, true)));
    out.println();
    out.println(line);
    printT("Successfully added and loaded "+keyWord+" \""+line+"\".");
  }
  catch(InvocationTargetException e) {
    throw (Exception)e.getCause();
  }
  catch(IOException e) {
    printException(e);
    printT("An error occurred while attempting to add "+keyWord+" \""+line+"\". This "+keyWord+" will not be loaded. See the above stack trace for details.");
  }
  finally {
    out.close();
  }
}

//---------------------------------------------------------------//
//-------------- Custom network stuff starts here  --------------//
//---------------------------------------------------------------//

void doNetListening() {
  //The first byte in a message indicates what type of message it is

  try {
    if (CurrentServer!=null) {
      Client c = CurrentServer.available();
      if (c!=null) {
        //If there is a message pending from a client
        //Get the type from the first byte
        byte type = (byte)c.read();
        //Get the rest of the message
        String message = c.readStringUntil(char(MSG_END_CHAR));
        //readStringUntil returns null if it did not find the terminating character
        if (message==null) {
          throw new ConnectException("Recieved malformed message from client: Failed to find message terminating character. (Message: \""+message+"\")");
        }
        //readStringUntil includes the terminating character, so remove it
        message = popCharacter(message);

        //Only check for types that are possible to receieve on a server
        switch(type) {
        case CLIENT_MSG:
          //If a client has sent a text message, print it and distribute it to all other clients

          String clientName = HostedClients.get(c);
          //If no given name, default to their IP address
          if (clientName == null) {
            clientName = c.ip();
          }

          //Print message
          writeServerMessage(clientName+": "+message, CLIENT_MSG);
          break;
        case JOIN_MSG:
          //If a client is joining, print it and inform other clients
          if (HostedClients.containsKey(c)) {
            throw new ConnectException("Recieved Join Message from client that is already connected. (Client: "+c+", Username: "+HostedClients.get(c)+", Client IP: "+c.ip()+")");
          }

          //printT("Recieved JOIN_MSG from Client on IP \""+c.ip()+"\" with submitted username \""+message+"\".");
          HostedClients.put(c, message);
          writeServerMessage("» "+message+" joined.", CLIENT_MSG);
          break;
        case LEAVE_MSG:
          //IF a client is leaving, print it and inform all other clients

          String ClientName = "";
          if (HostedClients.containsKey(c)) {
            ClientName = HostedClients.get(c);
            HostedClients.remove(c);
          } else {
            try {
              ClientName = c.ip();
            }
            catch(NullPointerException e) {
            }
          }

          //String msg2h = (ClientName.equals(c.ip())) ? "with no stored username." : "with stored username \""+ClientName+"\".";
          //printT("Recieved LEAVE_MSG from client on IP \""+c.ip()+"\" "+msg2h);
          writeServerMessage("» "+ClientName+" left.", CLIENT_MSG);
          CurrentServer.disconnect(c);
          break;
        case NAME_MSG:
          //If a client is telling us its name, store that information and tell other clients
          writeServerMessage(HostedClients.get(c)+" has changed their username to \""+message+"\".", CLIENT_MSG);
          HostedClients.put(c, message);
          break;
        case ONLINE_MSG:
          //If a client is requesting the list of online clients, tell them it
          printT("Client \""+c+"\" (\""+((HostedClients.get(c)==null)?"null":HostedClients.get(c))+"\") requested the online client list. Sending it to them...");

          String list = "";
          for (Client C : HostedClients.keySet ()) {
            list+="\""+HostedClients.get(C)+"\", ";
          }
          if (!list.equals("")) {
            list = popCharacter(popCharacter(list));
          }
          c.write(char(ONLINE_MSG)+list+char(MSG_END_CHAR));

          printT("Sent online client list to client:");
          printT(tabCharacter+"\""+list+"\"");
          break;
        default:
          //Throw an exception for unexpected types
          throw new ConnectException("Recieved malformed message from client: Message has invalid TYPE byte. (Type byte: \""+type+"\" \""+char(type)+"\", Message: \""+message+"\")");
        }
      }
    } else if (CurrentClient!=null) {
      //If we are a client
      //If the server has incoming messages
      if (CurrentClient.available()>0) {
        //Get the type byte
        byte type = (byte)CurrentClient.read();
        //Get the message
        String message = CurrentClient.readStringUntil(char(MSG_END_CHAR));
        //readStringUntil returns null if the terminating character was not found
        if (message==null) {
          throw new ConnectException("Recieved malformed message from server: Failed to find message terminating character. (Message: "+message+")");
        }
        //Remove trailing terminating character
        message = popCharacter(message);
        switch(type) {
        case SERVER_MSG:
          //If the server is sending us a message, print it
          printT("(Server) "+message);
          break;
        case CLIENT_MSG:
          //If the server is relaying a client message to us, print it
          printT(message);
          break;
        case LEAVE_MSG:
          //If the server is closing the connection, print it and shut off connection
          printT("Disconnected from server \""+Servername+"\" at IP \""+IP+"\" on port \""+Port+"\": \"Server closed by host.\"");
          Servername = null;
          IP = null;
          ConnectionExpected = false;
          Port = -1;
          CurrentClient = null;
          break;
        case KICK_MSG:
          //If we are being kicked, print it and shut off connection
          CurrentClient = null;
          ConnectionExpected = false;
          IP = null;
          Port = -1;
          printT("Disconnected from server: Kicked by host: \""+message+"\".");
          break;
        case NAME_MSG:
          //If the server is telling us information, store it and print it
          Servername = message;
          printT("Connected to server \""+Servername+"\" at IP \""+IP+"\" on port \""+Port+"\".");
          break;
        case ONLINE_MSG:
          //If the server is telling us who is online, print it
          String[] names = message.split(str(char(LIST_SEP_CHAR)));
          String list = "";
          for (String n : names) {
            list+=n+", ";
          }
          list = removeCharsInclusive(list, list.length()-2, list.length()-2);
          printT("Receieved list of other online clients from server: Connected clients: "+list);
          break;
        default:
          throw new ConnectException("Receieved malformed message from server: Message has illegal TYPE byte. (Type: \""+type+"\" \""+char(type)+"\", Message: \""+message+"\")");
        }
      }
    }
  }
  catch(ConnectException e) {
    printException(e);
  }
}

Client initClient(String host, int port) {
  //Creates a client object and returns it
  return new Client(this, host, port);
}

Server initServer(int port) {
  //Creates a server object and returns it
  return new Server(this, port);
}

void connectClient() {
  try {
    printT("Attempting to connect to server at IP \""+IP+"\" on port \""+Port+"\"...");
    CurrentClient = initClient(IP, Port);
    CurrentClient.ip();
    ConnectionExpected = true;
    CurrentClient.write(char(JOIN_MSG)+Username+char(MSG_END_CHAR));
  }
  catch(NullPointerException e) {
    CurrentClient = null;
    ConnectionExpected = false;
    printT("Unable to connect to server at IP \""+IP+"\" on port \""+Port+"\": ");
    printException(new UnknownHostException("This IP or Port is invalid, or there is no server on this IP and port."));
  }
}

void connectServer() {
  try {
    printT("Attempting to create server at IP \""+IP+"\" on port \""+Port+"\"...");
    CurrentServer = initServer(Port);
    HostedClients = new HashMap<Client, String>();
    Client c = initClient(Server.ip(), Port);
    c.ip();
    ConnectionExpected = true;
    c.stop();
    printT("Successfully created server at IP \""+IP+"\" on port \""+Port+"\".");
  }
  catch(NullPointerException e) {
    CurrentServer = null;
    ConnectionExpected = false;
    Servername = null;
    printT("Unable to create server at IP \""+IP+"\" on port \""+Port+"\": ");
    printException(new UnknownHostException("This port is invalid."));
  }
}

void performKick(String username, String reason) throws ConnectException {
  try {
    if (CurrentServer==null) {
      if (CurrentClient==null) {
        throw new ConnectException("Cannot kick clients off a connection that does not exist.");
      } else {
        throw new ConnectException("Cannot kick clients off a connection when you are a client.");
      }
    }
    if (HostedClients == null) {
      throw new ConnectException("Cannot kick clients off a connection that does not exist.");
    }
    for (Client c : HostedClients.keySet ()) {
      String name = HostedClients.get(c);
      if (username.equals(name)) {
        c.write(char(KICK_MSG)+reason+char(MSG_END_CHAR));
        HostedClients.remove(c);
        CurrentServer.disconnect(c);
        writeServerMessage(name+" has been kicked by the Server: \""+reason+"\".", CLIENT_MSG);
        return;
      }
    }
  }
  catch(ConnectException e) {
    throw e;
  }
  throw new IllegalArgumentException("Could not find a connected client with the username \""+username+"\".");
}

void serverEvent(Server s, Client c) {
  //Called on SERVER instance when a CLIENT connects to the server.
  //s is this server, c is the new client

  //Pass information to client
  c.write(char(NAME_MSG)+Servername+char(MSG_END_CHAR));
  printT("Written name msg to client:");
  printT(char(NAME_MSG)+Servername+char(MSG_END_CHAR));

  String list = "";
  for (Client C : HostedClients.keySet ()) {
    list+="\""+HostedClients.get(C)+"\", ";
  }
  if (!list.equals("")) {
    list = popCharacter(popCharacter(list));
  }
  c.write(char(ONLINE_MSG)+list+char(MSG_END_CHAR));

  printT("Written online msg to client:");
  printT(char(ONLINE_MSG)+list+char(MSG_END_CHAR));
  //  String online_list = "";
  //  for(Client C : HostedClients.keySet()){
  //    String name = HostedClients.get(C);
  //    online_list+=name+LIST_SEP_CHAR;
  //  }
  //  online_list = removeCharsInclusive(online_list,online_list.length()-1,online_list.length()-1);
  //  c.write(char(ONLINE_MSG)+online_list+MSG_END_CHAR);
}

void clientEvent(Client c) {
  //Called on CLIENT when recieved data from SERVER
  //c is client running on this instance
}

void disconnectEvent(Client c) {
  //Called on SERVER when a client DC's. Called on a CLIENT when client DC's from server
  //c is client that DC'd from server from server perspective, c is client that DC'd from server from client perspective
}

void writeServerMessage(String message, byte type) throws ConnectException {
  if (CurrentServer==null) {
    throw new ConnectException("Cannot write a message to a connection that does not exist.");
  }
  printT(message);
  CurrentServer.write(char(type)+message+char(MSG_END_CHAR));
}

//-------------------------------------------------------------//
//-------------- Custom network stuff ends here  --------------//
//-------------------------------------------------------------//

void printException(Exception e) {
  e.printStackTrace();
  printT(e.toString());
//  for (StackTraceElement s : e.getStackTrace ()) {
//    printT(tabCharacter+"at "+s.toString());
//  }
}

String collapseStringArray(String[] original, String seperator, int startIndex, int endIndex) {
  //Collapses a given string array into a single large string,
  //with each array entry being seperated by an instance of the given seperator string
  if (startIndex<0||startIndex>endIndex||startIndex>original.length||endIndex<0||endIndex>original.length) {
    throw new IllegalArgumentException("One or more invalid indexes. These must be within the bounds of the given array and startIndex must be less than endIndex.");
  }
  String result = "";
  for (int i=startIndex; i<endIndex; i++) {
    String entry = original[i];
    result+=entry;
    if (i<endIndex-1) {
      //Only append the seperator if we aren't at the end of the array
      result+=seperator;
    }
  }
  return result;
}

String insertCharacter(String original, String toInsert, int position) {
  String p1 = original.substring(0, position);
  String p2 = original.substring(position);
  return p1 + toInsert + p2;
}

String popCharacter(String original) {
  return removeCharsInclusive(original, original.length()-1, original.length()-1);
}

String removeCharsExclusive(String original, int start, int end) {
  //Removes all characters INBETWEEN the characters at the specified indexes, NOT INCLUDING characters AT the specified indexes
  if (start>=end) {
    throw new IllegalArgumentException("Start index must be less than end index.");
  }
  try {
    String p1 = original.substring(0, start+1);
    String p2 = original.substring(end);
    return p1 + p2;
  }
  catch(StringIndexOutOfBoundsException e) {
    printException(e);
    return null;
  }
}

String removeCharsInclusive(String original, int start, int end) {
  //Removes ALL characters FROM the start index TO the end index INCLUDING the characters AT the specified indexes
  if (start>end) {
    throw new IllegalArgumentException("Start index must be less than or equal to end index.");
  }
  try {
    String p1 = original.substring(0, start);
    String p2 = original.substring(end+1);
    return p1 + p2;
  }
  catch(StringIndexOutOfBoundsException e) {
    printException(e);
    return null;
  }
}

String replaceCharacters(String original, String toInsert, int start, int end) {
  //Replaces ALL characters within the specified indexes INCLUDING characters AT the specified indexes with one instance of the specified toReplace string
  if (start>end) {
    throw new IllegalArgumentException("Start index must be less than or equal to end index");
  }
  try {
    String p1 = original.substring(0, start);
    String p2 = original.substring(end+1);
    return p1 + toInsert + p2;
  }
  catch(StringIndexOutOfBoundsException e) {

    printException(e);
    return null;
  }
}

String replaceCharacters(String original, char toInsert, int start, int end) {
  //Replaces ALL characters within the specified indexes INCLUDING characters AT the specified indexes with one instance of the specified toReplace string
  if (start>end) {
    throw new IllegalArgumentException("Start index must be less than or equal to end index");
  }
  try {
    String p1 = original.substring(0, start);
    String p2 = original.substring(end+1);
    return p1 + toInsert + p2;
  }
  catch(StringIndexOutOfBoundsException e) {

    printException(e);
    return null;
  }
}

void keyPressed() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case LEFT:
      textPointIndex = constrain(textPointIndex-1, 0, BufferedText.length());
      resetTextPoint(true);
      break;
    case RIGHT:
      textPointIndex = constrain(textPointIndex+1, 0, BufferedText.length());
      resetTextPoint(true);
      break;
    }
    break;
  case BACKSPACE:
    if (textPointIndex>0) {
      BufferedText = BufferedText.substring(0, textPointIndex-1) + BufferedText.substring(textPointIndex);
      textPointIndex--;
      resetTextPoint(true);
    } else {
      resetTextPoint();
    }
    break;
  case TAB:
    BufferedText = insertCharacter(BufferedText, tabCharacter, textPointIndex);
    textPointIndex+=spacesInTab;
    resetTextPoint();
    break;
  case ENTER:
  case RETURN:
    //parseTextResponse(BufferedText);
    invokeTextResponse(BufferedText);
    BufferedText="";
    textPointIndex = 0;
    break;
  case ESC:
    exit();
    break;
  case DELETE:
    if (textPointIndex<BufferedText.length()) {
      BufferedText = BufferedText.substring(0, textPointIndex) + BufferedText.substring(textPointIndex+1);
      resetTextPoint(true);
    } else {
      resetTextPoint();
    }
    break;
  default:
    BufferedText = insertCharacter(BufferedText, str(key), textPointIndex);
    textPointIndex++;
    resetTextPoint();
    break;
  }
}

