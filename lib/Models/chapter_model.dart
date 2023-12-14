class ChapterModel {
  int? id;
  var bookId;
  String? name;
  String? description;
  String? pic;

  ChapterModel({this.id, this.bookId, this.name, this.description, this.pic});

  ChapterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookId = json['book_id'];
    name = json['name'];
    description = json['description'];
    pic = json['pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['book_id'] = bookId;
    data['name'] = name;
    data['description'] = description;
    data['pic'] = pic;
    return data;
  }
}
