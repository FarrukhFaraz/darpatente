class HomePageClass {
  String textA;
  String textB;
  double height;
  double width;
  double padding;

  // double textwidth;

  HomePageClass(
      this.textA,
      this.textB,
      this.height,
      this.width,
      this.padding,
      // this.textwidth,
      );
}

List<HomePageClass> getList() {
  List<HomePageClass> myyeList = [
    HomePageClass('assets/images/esame.png', 'Esame', 130, 700, 14.0),
    HomePageClass('assets/images/video lesson.png', 'Video Lezioni', 100, 130, 0),
    HomePageClass('assets/images/errori frequentati.png', 'Errori Frequenti', 100,
        700, 0),
    HomePageClass(
        'assets/images/ripasso errori.png', 'Ripasso Errori', 130, 700, 12.0),
    HomePageClass('assets/images/schede svolte.png', 'Schede Svolte', 130, 700, 10.0),
    HomePageClass('assets/images/progresso.png', 'Progresso', 130, 700, 10.0),
    HomePageClass(
      'assets/images/trucchiss.png',
      'Trucchi',
      130,
      700,
      10.0,
    ),
    HomePageClass('assets/images/Vocabolario.png', 'Vocabolario', 130, 700, 10.0),
  ];
  return myyeList;
}