class UsersByPastPaperModel {
  int? userId;
  int? wrong;
  Questions? questions;

  UsersByPastPaperModel({this.userId, this.wrong, this.questions});

  UsersByPastPaperModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    wrong = json['wrong'];
    questions = json['questions'] != null
        ? new Questions.fromJson(json['questions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['wrong'] = this.wrong;
    if (this.questions != null) {
      data['questions'] = this.questions!.toJson();
    }
    return data;
  }
}

class Questions {
  int? id;
  int? bookId;
  int? srNo;
  int? userId;
  String? examDate;
  String? time;
  String? qNo;
  String? question;
  String? image;
  String? optionA;
  String? optionB;
  String? answer;
  String? attempted;
  String? createdAt;
  String? updatedAt;
  User? user;

  Questions(
      {this.id,
      this.bookId,
      this.srNo,
      this.userId,
      this.examDate,
      this.time,
      this.qNo,
      this.question,
      this.image,
      this.optionA,
      this.optionB,
      this.answer,
      this.attempted,
      this.createdAt,
      this.updatedAt,
      this.user});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookId = json['book_id'];
    srNo = json['sr_no'];
    userId = json['user_id'];
    examDate = json['exam_date'];
    time = json['time'];
    qNo = json['q_no'];
    question = json['question'];
    image = json['image'];
    optionA = json['optionA'];
    optionB = json['optionB'];
    answer = json['answer'];
    attempted = json['attempted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['book_id'] = this.bookId;
    data['sr_no'] = this.srNo;
    data['user_id'] = this.userId;
    data['exam_date'] = this.examDate;
    data['time'] = this.time;
    data['q_no'] = this.qNo;
    data['question'] = this.question;
    data['image'] = this.image;
    data['optionA'] = this.optionA;
    data['optionB'] = this.optionB;
    data['answer'] = this.answer;
    data['attempted'] = this.attempted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
