public class Function{
  //int number;
  ArrayList<note> recorder;
  int playIndex;
  int startTime;

  Function() {
    recorder = new ArrayList<note>();
  }

  void startRecord(){
    recorder.clear();
  }

  void addNote(note enteringNote) {
    recorder.add(enteringNote); 
  }
  
  void startPlay(ArrayList<note> playStack){
    for (playIndex = recorder.size() - 1; playIndex >= 0; playIndex--){
      playStack.add(recorder.get(playIndex));
    }
  }
};
