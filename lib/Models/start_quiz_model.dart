class StartQuizClass {
  String date;
  String img;

  StartQuizClass(this.date, this.img);
}

List<StartQuizClass> getsList() {
  List<StartQuizClass> myyeList = [
    StartQuizClass('Simulazione esame', "assets/images/simulazione esame.png"),
    //// full book
    StartQuizClass('Per Capitolo', "assets/images/Per capitolo.png"),
    //// by chaper
    StartQuizClass(
        'Esercizio Per Argomento', 'assets/images/Per argumento.png'),
    //// by topic
  ];
  return myyeList;
}
