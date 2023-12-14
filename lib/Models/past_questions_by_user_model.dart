import 'dart:ui';

import '../Utils/colors.dart';

class PastPaperByQuestionModel {
  int? id;
  int? userId;
  String? qNo;
  String? question;
  String? image;
  String? optionA;
  String? optionB;
  String? answer;
  String? attempted;
  String? createdAt;
  String? updatedAt;

  Color backGroundColor = kWhite;
  String myAttempted = '';
  bool questionAttempted = false;
  int status = 0;
  bool op_vera = false;
  bool op_falsa = false;

  PastPaperByQuestionModel(
      {this.id,
        this.userId,
        this.qNo,
        this.question,
        this.image,
        this.optionA,
        this.optionB,
        this.answer,
        this.attempted,
        this.createdAt,
        this.updatedAt});

  PastPaperByQuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    qNo = json['q_no'];
    question = json['question'];
    image = json['image'];
    optionA = json['optionA'];
    optionB = json['optionB'];
    answer = json['answer'];
    attempted = json['attempted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['q_no'] = this.qNo;
    data['question'] = this.question;
    data['image'] = this.image;
    data['optionA'] = this.optionA;
    data['optionB'] = this.optionB;
    data['answer'] = this.answer;
    data['attempted'] = this.attempted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}