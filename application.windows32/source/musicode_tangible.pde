import processing.serial.*;
import cc.arduino.*;
import ddf.minim.*;

Minim minim;
Arduino arduino;

import java.util.Hashtable;
import java.util.Map;
import java.util.Set;
import java.util.Iterator;

// Note the HashMap's "key" is a String and "value" is an Integer
Hashtable hm = new Hashtable();

AudioPlayer player;

char inp;

ArrayList<note> playStack;
Function[] butts; //the storage of all the buttonses's records
int recorder;
int playing;
int lastTime;
int lastTime2;
int[] edges;
int[] edgeConditions;
int playIndex;
int delayTime;

int saveTime = 0;
int checking = 0;
int edgeTruth = 0;
note currentNote;
int low, high;
PFont f;
String playedString;
int qno;
String[] questionArray;
String question;
int programLength;
int[] lengths;
int bestLength;
int set;

void setup() {
  size(640, 360);
  noStroke();
  recorder = -1;
  playing = -1;
  lastTime = 0;
  lastTime2 = 0;
  edges = new int[4];
  initEdges();
  edgeConditions = new int[4];
  edgeConditions[0] = 0; edgeConditions[1] = 0;
  edgeConditions[2] = 0; edgeConditions[3] = 0;
  playIndex = 0;
  delayTime = 800;
  butts = new Function[2];
  butts[0] = new Function();
  butts[1] = new Function();
  playStack = new ArrayList<note>();
  minim = new Minim(this);
  f = createFont("Andale Mono",9,true);
  playedString = " ";
  programLength = 0;
  qno = 0;
  questionArray = new String[8];
  lengths = new int[8];
  questionArray[0] = "0 1 2"; questionArray[1] = "0 0 1 0 3 2";
  questionArray[2] = "0 1 0 1 0 1"; questionArray[3] = "0 0 1 0 3 2 0 0 1 0 4 3"; 
  questionArray[4] = "0 1 0 1 0 1 0 1 0 1 0 1 0 1"; questionArray[5] = "0 0 1 0 3 2 0 0 1 0 4 3";
  questionArray[6] = "0 0 1 0 3 2 0 0 1 0 4 3 0 0 1 0 3 2 0 0 1 0 4 3 0 0 1 0 3 2 0 0 1 0 4 3";
  
  lengths[0] = 3; lengths[1] = 7; lengths[2] = 5; lengths[3] = 10;
  lengths[4] = 3; lengths[5] = 10; lengths[6] = 11;
  
  question = questionArray[qno];
  bestLength = lengths[qno];
  
  set = 0; 
  
  //setupArduino();
}

void setupArduino(){
  // Putting key-value pairs in the HashMap
  hm.put(2, 'a');
  hm.put(3, 'b');//
  hm.put(4, 'c');//
  hm.put(5, 'd');//
  hm.put(6, 'e');
  hm.put(7, 'f');
  hm.put(8, 'g');//
  hm.put(9, 'h');
  hm.put(10, 'p');
  hm.put(11, '1');
  hm.put(30, '2');
  hm.put(31, '3');
  hm.put(32, '4');
  hm.put(12, '5');
  hm.put(34, '6');
  hm.put(35, '7');
  hm.put(36, '8');
  hm.put(37, 'm');
  hm.put(38, 'n');
  low = 3;
  high = 12;
  
  
  //arduino mega
  
  /*hm.put(22, 'a');
  hm.put(23, 'b');//
  hm.put(24, 'c');//
  hm.put(25, 'd');//
  hm.put(26, 'e');
  hm.put(27, 'f');
  hm.put(28, 'g');//leftButton
  hm.put(29, 'h');
  hm.put(30, 'p');
  hm.put(31, '1');
  hm.put(32, '2');
  hm.put(33, '3');
  hm.put(34, '4');
  hm.put(35, '5');
  hm.put(36, '6');
  hm.put(37, '7');
  hm.put(38, '8');
  hm.put(39, 'p');
  low = 22;
  high = 39;
  */
  
  
  inp = ' ';
  
 // Prints out the available serial ports.
 println(Arduino.list());
 arduino = new Arduino(this, Arduino.list()[0], 57600);
  for (int i = low; i <= high; i++)
    arduino.pinMode(i, Arduino.INPUT);
    
  Iterator i = hm.entrySet().iterator();  // Get an iterator

  while (i.hasNext()){
    Map.Entry me = (Map.Entry)i.next();
    print(me.getKey() + " is ");
    println(me.getValue());
  }
  arduino.pinMode(2, Arduino.OUTPUT);
  arduino.digitalWrite(2, Arduino.HIGH);
}

void initEdges(){
  edges[0] = 0;
  edges[1] = 0;
  edges[2] = 0;
  edges[3] = 0;
}

void updateSignals(char current){

  boolean press = false;
  for (int i = low; i <= high; i++)
  {
    current = hm.get(i).toString().charAt(0);
    
    //println(arduino.digitalRead(i)+" ");
    if (arduino.digitalRead(i) == Arduino.HIGH)
    {
      if(inp!=current && millis() - saveTime > 2000)
      {
        inp = current;
        press = true;
        saveTime = millis();
        break;
      }
    }
  }
  
  //send inp to keyPressedChecker
  if(press)
  {
    keyPressedCheck(inp);
    inp = ' ';
  }
}

String getText(note thisNote){
  String type = " ";
  String number = str(thisNote.number);
  if (thisNote.kind == 0){
    type = "note ";
    type += number;
  }
  else if (thisNote.kind == 1){
    type = "function";
    number = str(thisNote.number + 1);
    type += number;
    type += "()";
  }
  else if (thisNote.kind == 2){
    type = "edge";
    type += number;
    type += "()";
  }
  else if (thisNote.kind == 3){
    type = "if edge";
    type += number;
    type += " == true";
  }
  return type;
}

void updateHighlights(){
  //rect(110, )
  float startX = 0;
  float startY = 0;
  if(currentNote != null){
    noFill();
    stroke(255);
    startX = 10 + 120 * (currentNote.funcNumb);
    startY = 40 + 20 * (currentNote.index);
    rect(startX - 6, startY - 12, 80, 18);
  }
}

void checkStatus(){
  int less = 0;
  less = question.length();
  if (playedString.length() < less)
    less = playedString.length();
  //int check = 1;
  fill(0, 255, 230);
  if (less > 1)
    if(!playedString.substring(0, less).equals(question.substring(0, less))){
      fill(255, 30, 30);
    } 
}

void printRecords(){
  text("Function 1", 10, 20);
  text("Function 2", 130, 20);
  for (int j = 0; j < 2; j++) {
    for(int i = 0; i < butts[j].recorder.size(); i++){
      note thisNote = butts[j].recorder.get(i);
      String noteText = getText(thisNote);
      text(noteText, 10 + 120*j, 40 + 20*i);
    }
  }
  
  text("Number of Instructions:", 300, 40, 640, 360);
  text(str(programLength) + " / " + bestLength, 300, 70, 350, 400);
  
  text("Question:", 300, 110, 640, 360);
  text(question, 300, 140, 350, 400);
  
  text("Output:", 300, 190, 640, 360);
  //choose fill color by checking
  checkStatus();
  
  text(playedString, 300, 220, 350, 400);
  
  if(playing != -1){
    updateHighlights();
  }  
}

void draw() {
  background(0);
  //when buttons are pressed
  //call playButton, edgeButton, noteButton, 
  //and functionButton on appropriate presses   
  //check for key event
    //check for key event
  boolean press = false, unpause = false;
  char current=' ';
  //updateSignals(current);
  //in appropriate playButton press, startPlay is called.
  //here the time cycle starts
  
  textFont(f,15);
  fill(0, 255, 0);
  
  if (playing != -1) {
    int now = millis();
    if (now - lastTime > 750){
      lastTime = now;
      if (currentNote != null)
        endNote(currentNote);
      initEdges();
      if(playStack.size() > 0){
        playIndex = playStack.size() - 1;
        playNote(playIndex);
        playIndex--;
      }
      else {
        playing = -1;
      }
    }
    else if(checking == 1){
      checkCondition(currentNote.number);
    }
  }
  
  printRecords();
  //startPlay stacks function 1, and starts running down.
  //it calls playnote, to execute topmost note of playstack.
  
  //playnote checks if it's a function call, edge call, note call, or condition
  //and does the corresponding action.
  
  /*if(playing != -1){
    lastTime2 = millis();
    checkEdgeInputs();
  }*/
  question = questionArray[qno];
  bestLength = lengths[qno];
}

/*void checkEdgeInputs(){
  int now;
  int edgeTruth = 0;
  now = millis();
  while(now - lastTime < delayTime || edgeTruth == 0){
    
    now = millis();
  }
  initEdges();
}
*/

//playing functions

void endTime(note Note){
  //endTime();

  
}

void playMusic(note Note){
  println("note " + str(Note.number));
  Note.reload();
  Note.play();
  playedString += str(Note.number) + " ";
  //endTime(Note);
}

void callEdge(int number){
  println("edge " + str(number));
  //edgeIn(number);
  //send LOW to led or stuff
  arduino.digitalWrite(2, Arduino.LOW);
}

void stackFunction(int number){
  butts[number].startPlay(playStack);
  playIndex = playStack.size() - 1;
  playNote(playIndex);
}

void endCondition(){
  if (edgeTruth == 0){
    //remove all following conditions if edgetruth is 0
    //and then remove the next note
    println("Happened!");
    if(playIndex > 0)
      playStack.remove(playIndex);
  }
  initEdges();
  checking = 0;
  edgeTruth = 0;
}

void checkCondition(int number){
 
  if(edges[number] == 1){
    
    edgeTruth = 1;
    //println("OOO");
  }
}

void endNote(note Note){
  if (currentNote.kind == 0){
    endTime(currentNote);
  }
  else if (currentNote.kind == 1){
    //nothing shold be done
    //functions are anyway stacked on and their top element is passed on to
  }
  else if (currentNote.kind == 2){
    //switch the edge call port to low
    arduino.digitalWrite(2, Arduino.HIGH);
  }
  else if (currentNote.kind == 3){
    endCondition();
  }
}

void playNote(int playIndex){
  note thisNote = playStack.get(playIndex);
  //remove from play stack
  //now either call edge, note, stack function, or check condition.
  currentNote = thisNote;
  playStack.remove(playIndex);
  if (thisNote.kind == 0){
    playMusic(thisNote);
  }
  else if (thisNote.kind == 1){
    stackFunction(thisNote.number);
  }
  else if (thisNote.kind == 2){
    callEdge(thisNote.number);
  }
  else if (thisNote.kind == 3){
    checking = 1;
    checkCondition(thisNote.number);
  }
}

void playNoteNow(){
  playIndex = playStack.size() - 1;
  lastTime = millis();
  playNote(playIndex);
  playIndex--;
  if (playStack.size() > 0 && playing != -1){
    playNoteNow();
  }
}

void startPlay(){
  playStack.clear();
  butts[0].startPlay(playStack);
  playedString = "";
  //playNoteNow();
  //playing = -1;
}

void edgeIn(int number){
  //if it received a signal from an edge
  edges[number] = 1;
}

//recording functions
void startRecording(int functionNumber) {
  butts[functionNumber].startRecord();
  recorder = functionNumber;
}

void addToRecorder(int button, int type){
  note thisNote;
  thisNote = new note(button, type, recorder, butts[recorder].recorder.size(), set);
  butts[recorder].addNote(thisNote);
  programLength = butts[0].recorder.size() + butts[1].recorder.size();
}

//all the calls when different buttons are pressed 

void functionButtonPress(int functionNumber) {
  //println("Function button");
  if (playing == -1) {
    //println("Not playing abhi");
    if (recorder == -1) {
      //println("Function ", functionNumber, " starts recording");
      startRecording(functionNumber);
      recorder = functionNumber;
    }
    else {
      //println("function ", functionNumber, " recorded");
      addToRecorder(functionNumber, 1);
    }
  }
}

void noteButtonPress(int note){
  //println("Note button");
  if(recorder != -1){
    //println("Recording note ", note);
    addToRecorder(note, 0);
  }
  else{
    //note thisNote = new note(note, 0); //play tone for testing, attempts pending
    //thisNote.play();
  }
}

void edgeButtonPress(int number, int type){ 
  //type = 0 is for out i.e. call, 
  //1 is for in i.e. if receiving/condition for next step
  println("Edge button");
  if(recorder != -1){
    println("Edge button " + str(number) +str(type));
    addToRecorder(number, type + 2);
  }
  //else if(recorder == -1){
    
  //}
  else if(playing != -1){
    if(type == 1)
      edgeIn(number);
  }
  //***add edge input conditions when recorder is off
  
}

void playButtonPress(){
  println("Play Button Press");
  if (playing == 1){
    //playing = 0; - pause attempts pending
    println("Stopping play");
    playing = -1;
  }
  /*else if (playing == 0){
    
  }*/
  else{
    if(recorder != -1){
      println("Stopping recording");
      recorder = -1;
    }
    else{
      playing = 1;
      println("Starting play");
      startPlay();
    }
  }
}
//button presses finished

void changeQuestion(int dir){
  if (dir == 1){
    if(qno < 7)
      qno += 1;
  }
  else if (dir == 0){
    if(qno > 0)
      qno -= 1;
  }
}

void keyPressedCheck(char KEY) {
  println(KEY);
  int keyIndex = -1;
  if (KEY == 'p'){
    println("Play notes!");
    playButtonPress();
  }
  else if (KEY >= '5' && KEY <= '8'){
    keyIndex = KEY - '5';
    println(keyIndex);
    edgeButtonPress(keyIndex, 1);
  }
  else if (playing == -1){
    if (KEY >= 'g' && KEY <= 'h'){
      keyIndex = KEY - 'g';
      println(keyIndex);
      functionButtonPress(keyIndex);
    }
    //sender buttons
    else if (KEY >= '1' && KEY <= '4'){
      keyIndex = KEY - '1';
      println(keyIndex);
      edgeButtonPress(keyIndex, 0);
    }
    //check condition buttons
//    else if (KEY >= '5' && KEY <= '8'){
//      keyIndex = KEY - '5';
//      println(keyIndex);
//      edgeButtonPress(keyIndex, 1);
//    }
    else if (KEY >= 'a' && KEY <= 'f'){
      keyIndex = KEY - 'a';
      println(keyIndex);
      noteButtonPress(keyIndex);
    }
    
    else if (KEY == 'm' || KEY == 'n'){
      keyIndex = 'n' - KEY;
      changeQuestion(keyIndex);
    }
    else
    {
      println("WRONG BUTTON PRESSED");
    }
  }
}

void keyPressed()
{
  inp = key;
  //send inp to keyPressedChecker
  keyPressedCheck(inp);
  inp = ' ';
}
