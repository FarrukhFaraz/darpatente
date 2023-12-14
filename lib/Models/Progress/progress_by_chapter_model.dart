class ProgressByChapterModel {
  int? totalQuiz;
  int? pass;
  int? fail;
  Chapter? chapter;

  ProgressByChapterModel({this.totalQuiz, this.pass, this.fail, this.chapter});

  ProgressByChapterModel.fromJson(Map<String, dynamic> json) {
    totalQuiz = json['total_quiz'];
    pass = json['pass'];
    fail = json['fail'];
    chapter =
        json['chapter'] != null ? new Chapter.fromJson(json['chapter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_quiz'] = this.totalQuiz;
    data['pass'] = this.pass;
    data['fail'] = this.fail;
    if (this.chapter != null) {
      data['chapter'] = this.chapter!.toJson();
    }
    return data;
  }
}

class Chapter {
  int? id;
  int? bookId;
  String? name;
  String? description;
  String? pic;
  String? createdAt;
  String? updatedAt;

  Chapter(
      {this.id,
      this.bookId,
      this.name,
      this.description,
      this.pic,
      this.createdAt,
      this.updatedAt});

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookId = json['book_id'];
    name = json['name'];
    description = json['description'];
    pic = json['pic'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['book_id'] = this.bookId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['pic'] = this.pic;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
