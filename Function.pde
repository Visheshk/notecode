public class Function{
  //int number;
  int[][] recorder;
  int i;
  int playIndex;
  int startTime;

  Function() {
    i = 0;
    recorder = new int[10][2];
  }

  void record(int time) {
    startTime = time;
  }

  void addNote(int not, int time) {
    recorder[i][0] = not;
    recorder[i][1] = time - startTime; 
    i++;
  }
  
  void startPlay(ArrayList<note> playStack){
    for (playIndex = i - 1; playIndex >= 0; playIndex--){
      note thisNote;
      thisNote = new note(recorder[playIndex][0], recorder[playIndex][1]);
      playStack.add(thisNote);
    }
  }
};
