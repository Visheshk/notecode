public class note {
  int number;
  int kind;
  int funcNumb;
  int index; 
  int noteSet;
  AudioPlayer notePlay;
  //0 is for individual notes
  //1 is for function calls
  //2 is for edge calls  //0, 1 and 2 behave identically for the circuit
  //3 is for conditionals
  
  note(int button, int type, int set) {    
    number = button;
    kind = type;
    if(kind == 0)
    {
      //notePlay = minim.loadFile(GetMusic(number, set), 2048);
    }
  }
  
  note(int button, int type, int fNumber, int slot, int set) {    
    number = button;
    kind = type;
    funcNumb = fNumber;
    index = slot;
    noteSet = set;
    if (kind == 0)
    {
      notePlay = minim.loadFile(GetMusic(number, noteSet), 2048);
      notePlay.play();
    }
  }
  
  void play(){
    //makeSound(press);
    notePlay.play();
  }
  
  void reload()
  {
    notePlay = minim.loadFile(GetMusic(number, noteSet), 2048);
  }
  
  String GetMusic(int number, int set)
  {
    String ret = "";
    if(number == 0)
    {
      ret = "C.wav";
    }
    if(number == 1)
    {
      ret = "D.wav";
    }
    if(number == 2)
    {
      ret = "E.wav";
    }
    if(number == 3)
    {
      ret = "F.wav";
    }
    if(number == 4)
    {
      ret = "G.wav";
    }
    if(number == 5)
    {
      ret = "B.wav";
    }
    return ret;
    
  }
}
