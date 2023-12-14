class PastPaperUserModel {
  int? total;
  int? wrong;
  User? user;

  PastPaperUserModel({this.total, this.wrong, this.user});

  PastPaperUserModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    wrong = json['wrong'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['wrong'] = this.wrong;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? bookId;
  String? name;
  String? examDate;
  String? time;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.bookId,
      this.name,
      this.examDate,
      this.time,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookId = json['book_id'];
    name = json['name'];
    examDate = json['exam_date'];
    time = json['time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['book_id'] = this.bookId;
    data['name'] = this.name;
    data['exam_date'] = this.examDate;
    data['time'] = this.time;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
