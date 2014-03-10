public class Function{
  //int number;
  int[][] recorder;
  int i;
  int playIndex;
  long int startTime;

  Function() {
    i = 0;
  }

  void record(int time) {
    startTime = time;
  }

  void addNote(int not, int time) {
    recorder[i][0] = not;
    recorder[i][1] = time - startTime; 
    i++;
  }
  
  void startPlay(){
    for (playIndex = i - 1; playIndex >= 0; playIndex--){
      thisNote = new note(recorder[playIndex][0], recorder[playIndex][1]);
      playStack.add(thisNote);
    }
  }
};
