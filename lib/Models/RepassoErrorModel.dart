class RepassoErrorModel {
  Chapter? chapter;
  var trueQuestions;
  var falseQuestions;
  var totalQuestions;

  RepassoErrorModel({
    this.chapter,
    this.trueQuestions,
    this.falseQuestions,
    this.totalQuestions,
  });

  RepassoErrorModel.fromJson(Map<String, dynamic> json) {
    chapter =
        json['chapter'] != null ? Chapter.fromJson(json['chapter']) : null;
    trueQuestions = json['true_questions'];
    falseQuestions = json['false_questions'];
    totalQuestions = json['total_questions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chapter != null) {
      data['chapter'] = chapter!.toJson();
    }
    data['true_questions'] = trueQuestions;
    data['false_questions'] = falseQuestions;
    data['total_questions'] = totalQuestions;
    return data;
  }
}

class Chapter {
  int? id;
  var bookId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['book_id'] = bookId;
    data['name'] = name;
    data['description'] = description;
    data['pic'] = pic;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
