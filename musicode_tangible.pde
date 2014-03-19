ArrayList<note> playStack;
Function[] butts; //the storage of all the buttonses's records
int recorder;
int playing = 0;

void setup() {
  size(640, 360);
  noStroke();
  recorder = -1;
  butts = new Function[2];
  butts[0] = new Function();
  butts[1] = new Function();
  playStack = new ArrayList<note>();
}

void draw() {

  //check for key event
  
  //on function button press, start recording
  
    //recording function calls addNote(note-integer, millis()). note-integer is 11 if function 2, 10 if function 1
      //if note-integer refers to same function, stop recording

  //on play button press, load function 1 to playStack
  
    //enter playstack
    //if playStack element is a function
      //stack that mofo
      //else play playStack element.
  

}

void playNotes(){
  int i = playStack.size() - 1;
  while (playStack.size() > 0){
    i = playStack.size() - 1;
    note currNote = playStack.get(i);
    playStack.remove(i);
    if (currNote.press < 10){
      currNote.play();
    }
    else{
      butts[currNote.press - 10].startPlay(playStack);
    }
  }
}

void startPlaying(){
  if (recorder == -1){
    butts[0].startPlay(playStack);
  }
  playNotes();
}

void keyPressed(){
  int keyIndex = -1;
  if (playing == 0){
    if (key == 'a'){
      if (recorder == -1){
        //start recording function 1
        recorder = 0;
        butts[0].record(millis());
      }
      else if (recorder == 0){
        //stop recording
        recorder = -1;
      }
      else if (recorder == 1){
        //add function 1, i.e. 10 to function being recorded
        butts[recorder].addNote(10, millis());
      }
    }
    else if (key == 'b'){
      if (recorder == -1){
        //start recording function 2
        recorder = 1;
        butts[1].record(millis());
      }
      else if (recorder == 1){
        //stop recording
        recorder = -1;
      }
      else if (recorder == 0){
        //add function 1, i.e. 11 to function being recorded
        butts[recorder].addNote(11, millis());
      }
    }
    else if (key >= 'c' && key <= 'f' && recorder != -1){
      keyIndex = key - 'c';
      butts[recorder].addNote(keyIndex, millis());
    }
    
    else if (key == 'p'){
      startPlaying();
    }
  }
}
