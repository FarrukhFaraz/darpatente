import 'dart:ui';

import '../Utils/colors.dart';

class RepasoErroriQuestionModel {
  int? id;
  int? questionNo;
  String? name;
  String? questionPicture;
  String? extraPicture;
  String? voice;
  String? answer;
  int? userId;
  int? quesId;
  String? quizeId;
  String? attempted;
  String? type;
  String? status;
  int? catId;
  int? totalQuestion;
  String? createdAt;
  String? updatedAt;


  Color backGroundColor = kWhite;
  String myAttempted = '';
  bool questionAttempted = false;
  bool op_vera = false;
  bool op_falsa = false;


  RepasoErroriQuestionModel(
      {this.id,
        this.questionNo,
        this.name,
        this.questionPicture,
        this.extraPicture,
        this.voice,
        this.answer,
        this.userId,
        this.quesId,
        this.quizeId,
        this.attempted,
        this.type,
        this.status,
        this.catId,
        this.totalQuestion,
        this.createdAt,
        this.updatedAt});

  RepasoErroriQuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionNo = json['question_no'];
    name = json['name'];
    questionPicture = json['question_picture'];
    extraPicture = json['extra_picture'];
    voice = json['voice'];
    answer = json['answer'];
    userId = json['user_id'];
    quesId = json['ques_id'];
    quizeId = json['quize_id'];
    attempted = json['attempted'];
    type = json['type'];
    status = json['status'];
    catId = json['cat_id'];
    totalQuestion = json['total_question'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_no'] = this.questionNo;
    data['name'] = this.name;
    data['question_picture'] = this.questionPicture;
    data['extra_picture'] = this.extraPicture;
    data['voice'] = this.voice;
    data['answer'] = this.answer;
    data['user_id'] = this.userId;
    data['ques_id'] = this.quesId;
    data['quize_id'] = this.quizeId;
    data['attempted'] = this.attempted;
    data['type'] = this.type;
    data['status'] = this.status;
    data['cat_id'] = this.catId;
    data['total_question'] = this.totalQuestion;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}