ArrayList<note> playStack;
Function[] butts; //the storage of all the buttonses's records
int recorder;
int playing;
int lastTime;
int[] edges;
int playIndex;

void setup() {
  size(640, 360);
  noStroke();
  recorder = -1;
  playing = -1;
  edges = new int[4];
  initEdges();
  playIndex = 0;
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
  
}

//playing functions

void endTime(){
  int now;
  now = millis();
  while (now - lastTime < 500){
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
  while (now - lastTime < 500 || edgeTruth == 1){
    if(edges[number] == 1){
      edgeTruth = 1;
    }
  }
  
  if (edgeTruth == 0){
    //remove all following conditions if edgetruth is 0
    //and then remove the next note
    if(playIndex > 0)
      playStack.remove(playIndex - 1);
  }
  initEdges();
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
  thisNote = new note(button, type);
  butts[recorder].addNote(thisNote);
}
//

//all the calls when different buttons are pressed 

void functionButtonPress(int functionNumber) {
  if (playing != -1) {
    if (recorder != -1) {
      startRecording(functionNumber);
    }
    else {
      addToRecorder(functionNumber, 1);
    }
  }
}

void noteButtonPress(int note){
  if(recorder != -1){
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
  if(recorder != -1){
    addToRecorder(number, type + 2);
  }
  
  //***add edge input conditions when recorder is off
  
}

void playButtonPress(){
  if (playing == 1){
    //playing = 0; - pause attempts pending
    playing = -1;
  }
  /*else if (playing == 0){
    
  }*/
  else{
    if(recorder != -1){
      recorder = -1;
    }
    else{
      playing = 1;
      startPlay();
    }
  }
}
//button presses finished

/*void playNotes() {
  int i = playStack.size() - 1;
  while (playStack.size () > 0) {
    i = playStack.size() - 1;
    note currNote = playStack.get(i);
    playStack.remove(i);
    if (currNote.press < 10) {
      currNote.play();
    }
    else {
      butts[currNote.press - 10].startPlay(playStack);
    }
  }
}

void startPlaying() {
  if (recorder == -1) {
    butts[0].startPlay(playStack);
  }
  playNotes();
}*/

/*
void keyPressed() {
  int keyIndex = -1;
  if (playing == 0) {
    if (key == 'a') {
      if (recorder == -1) {
        //start recording function 1
        recorder = 0;
        butts[0].record(millis());
      }
      else if (recorder == 0) {
        //stop recording
        recorder = -1;
      }
      else if (recorder == 1) {
        //add function 1, i.e. 10 to function being recorded
        butts[recorder].addNote(10, millis());
      }
    }
    else if (key == 'b') {
      if (recorder == -1) {
        //start recording function 2
        recorder = 1;
        butts[1].record(millis());
      }
      else if (recorder == 1) {
        //stop recording
        recorder = -1;
      }
      else if (recorder == 0) {
        //add function 1, i.e. 11 to function being recorded
        butts[recorder].addNote(11, millis());
      }
    }
    else if (key >= 'c' && key <= 'f' && recorder != -1) {
      keyIndex = key - 'c';
      butts[recorder].addNote(keyIndex, millis());
    }

    else if (key == 'p') {
      startPlaying();
    }
  }
}
*/

void keyPressed(){
  
}
