ArrayList<note> playStack;
Function[] butts; //the storage of all the buttonses's records
int recorder;
int playing;
int lastTime;
int lastTime2;
int edgeChecking;
int[] edges;
int[] edgeConditions;
int playIndex;
int delayTime;

void setup() {
  size(640, 360);
  noStroke();
  recorder = -1;
  playing = -1;
  lastTime = 0;
  lastTime2 = 0;
  edgeChecking = 0;
  edges = new int[4];
  initEdges();
  edgeConditions[0] = 0; edgeConditions[1] = 0;
  edgeConditions[2] = 0; edgeConditions[3] = 0;
  playIndex = 0;
  delayTime = 500;
  butts = new Function[2];
  butts[0] = new Function();
  butts[1] = new Function();
  playStack = new ArrayList<note>();
}

void initEdges(){
  edges[0] = 0;
  edges[1] = 0;
  edges[2] = 0;
  edges[3] = 0;
}

void draw() {

  //when buttons are pressed
  //call playButton, edgeButton, noteButton, 
  //and functionButton on appropriate presses   
  
  //in appropriate playButton press, startPlay is called.
  //here the time cycle starts
  
  //startPlay stacks function 1, and starts running down.
  //it calls playnote, to execute topmost note of playstack.
  
  //playnote checks if it's a function call, edge call, note call, or condition
  //and does the corresponding action.
  /*
  if(playing != -1){
    lastTime2 = millis();
    checkEdgeInputs();
  }
  */
}
/*
void checkEdgeInput(){
  int now;
  int edgeTruth = 0;
  now = millis();
  while(now - lastTime < delayTime || edgeTruth == 0){
    
    now = millis()
  }
  initEdges();
}*/

//playing functions
void endTime(){
  int now;
  now = millis();
  while (now - lastTime < delayTime){
    now = millis();
  } 
}

void playMusic(int number){
  println("note ", number);
  endTime();
}

void callEdge(int number){
  println("edge ", number);
  endTime();
}

void stackFunction(int number){
  butts[number].startPlay(playStack);
}

void checkCondition(int number){
  int now;
  now = millis();
  int edgeTruth;
  edgeTruth = 0;
  while (now - lastTime < 500 || edgeTruth == 0){
    edgeChecking = 1;
    if(edges[number] == 1){
      edgeTruth = 1;
    }
  }
  
  if (edgeTruth == 1){
    //remove all following conditions if edgetruth is 0
    //and then remove the next note
    if(playIndex > 0)
      playStack.remove(playIndex - 1);
  }
  initEdges();
  edgeChecking = 0;
}

void playNote(int playIndex){
  note thisNote = playStack.get(playIndex);
  //remove from play stack
  //now either call edge, note, stack function, or check condition.
  playStack.remove(playIndex);
  if (thisNote.kind == 0){
    playMusic(thisNote.number);
  }
  else if (thisNote.kind == 1){
    stackFunction(thisNote.number);
  }
  else if (thisNote.kind == 2){
    callEdge(thisNote.number);
  }
  else if (thisNote.kind == 3){
    checkCondition(thisNote.number);
  }
  
}

void startPlay(){
  butts[0].startPlay(playStack);
  lastTime = millis();
  while (playStack.size() > 0){
    playIndex = playStack.size() - 1;
    playNote(playIndex);
    playIndex--;
    lastTime = millis();
  }
  playing = -1;
}

/*void edgeIn(int number){
  //if it received a signal from an edge
  edges[number] = 1;
}*/



//recording functions
void startRecording(int functionNumber) {
  butts[functionNumber].startRecord();
  recorder = functionNumber;
}

void addToRecorder(int button, int type){
  note thisNote;
  thisNote = new note(button, type);
  butts[recorder].addNote(thisNote);
}
//

//all the calls when different buttons are pressed 

void functionButtonPress(int functionNumber) {
  println("Function button");
  if (playing == -1) {
    println("Not playing abhi");
    if (recorder == -1) {
      println("Function ", functionNumber, " starts recording");
      startRecording(functionNumber);
      recorder = functionNumber;
    }
    else {
      println("function ", functionNumber, " recorded");
      addToRecorder(functionNumber, 1);
    }
  }
}

void noteButtonPress(int note){
  println("Note button");
  if(recorder != -1){
    println("Recording note ", note);
    addToRecorder(note, 0);
  }
  else{
    //thisNote = new note(note, 0); //play tone for testing, attempts pending
    //thisNote.play();
  }
}

void edgeButtonPress(int number, int type){ 
  //type = 0 is for out i.e. call, 
  //1 is for in i.e. if receiving/condition for next step
  println("Edge button");
  if(recorder != -1){
    println("Edge button ", number, type);
    addToRecorder(number, type + 2);
  }
  else if(edgeChecking == 1 && type == 1){
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

void keyPressed(){
  int keyIndex = -1;
  if (key == 'p'){
    playButtonPress();
  }
  else if (playing == -1){
    if (key >= 'g' && key <= 'h'){
      keyIndex = key - 'g';
      println(keyIndex);
      functionButtonPress(keyIndex);
    }
    else if (key >= '1' && key <= '4'){
      keyIndex = key - '1';
      println(keyIndex);
      edgeButtonPress(keyIndex, 0);
    }
    else if (key >= '5' && key <= '8'){
      keyIndex = key - '5';
      println(keyIndex);
      edgeButtonPress(keyIndex, 1);
    }
    else if (key >= 'a' && key <= 'f'){
      keyIndex = key - 'a';
      println(keyIndex);
      noteButtonPress(keyIndex);
    }
  }
}
