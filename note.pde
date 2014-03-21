public class note {
  int number;
  int kind; 
  //0 is for individual notes
  //1 is for function calls
  //2 is for edge calls  //0, 1 and 2 behave identically for the circuit
  //3 is for conditionals
  
  note(int button, int type) {
    number = button;
    kind = type;
  }
  
  void play(){
    //makeSound(press);
    println(press, time);
  }
}
