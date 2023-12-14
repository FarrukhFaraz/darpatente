


class MyLanguageClass{
  String? name;
  String? value;

  MyLanguageClass({
    required this.name,
    required this.value
  });

}

List<MyLanguageClass> getMyClassList(){
  List<MyLanguageClass> myList = [
    MyLanguageClass(name: 'Urdu', value: 'urdu'),
    MyLanguageClass(name: 'Hindi', value: 'hindi'),
    MyLanguageClass(name: 'Punjabi', value: 'punjabi'),
    MyLanguageClass(name: 'Bangali', value: 'bangali'),
    MyLanguageClass(name: 'Forsi', value: 'forsi'),
  ];

  return myList;
}