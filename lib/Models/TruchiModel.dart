class TruchiModel {
  int? id;
  String? words;
  int? catId;
  String? answer;
  String? questionNo;
  String? createdAt;
  String? updatedAt;

  TruchiModel(
      {this.id,
        this.words,
        this.catId,
        this.answer,
        this.questionNo,
        this.createdAt,
        this.updatedAt});

  TruchiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    words = json['words'];
    catId = json['cat_id'];
    answer = json['answer'];
    questionNo = json['question_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['words'] = this.words;
    data['cat_id'] = this.catId;
    data['answer'] = this.answer;
    data['question_no'] = this.questionNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}