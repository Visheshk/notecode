public class note {
  int press;
  int time;
  
  note(int button, int lag) {
    press = button;
    time = lag;
  }
  
  void play(){
    //makeSound(press);
    println(press, time);
  }
}
