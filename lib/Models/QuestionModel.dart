import 'dart:ui';

import '../Utils/colors.dart';



class QuestionModel {
  int? id;
  String? name;
  int? bookId;
  int? chapterId;
  int? topicId;
  String? option1;
  String? option2;
  String? answer;
  String? condition;
  String? createdAt;
  String? updatedAt;
  String? questionNo;
  var questionPicture;
  String? voice;
  var questionPictureSymbol;
  Topic? topic;

  Color backGroundColor = kWhite;
  bool questionAttempted = false;
  int status = 0;
  bool op_vera = false;
  bool op_falsa = false;

  String myAttempted = '';


  QuestionModel(
      {this.id,
      this.name,
      this.bookId,
      this.chapterId,
      this.topicId,
      this.option1,
      this.option2,
      this.answer,
      this.condition,
      this.createdAt,
      this.updatedAt,
      this.questionNo,
      this.questionPicture,
      this.voice,
      this.questionPictureSymbol,
      this.topic});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bookId = json['book_id'];
    chapterId = json['chapter_id'];
    topicId = json['topic_id'];
    option1 = json['option1'];
    option2 = json['option2'];
    answer = json['answer'];
    condition = json['condition'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    questionNo = json['question_no'];
    questionPicture = json['question_picture'];
    voice = json['voice'];
    questionPictureSymbol = json['question_picture_symbol'];
    topic = json['topic'] != null ? new Topic.fromJson(json['topic']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['book_id'] = this.bookId;
    data['chapter_id'] = this.chapterId;
    data['topic_id'] = this.topicId;
    data['option1'] = this.option1;
    data['option2'] = this.option2;
    data['answer'] = this.answer;
    data['condition'] = this.condition;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['question_no'] = this.questionNo;
    data['question_picture'] = this.questionPicture;
    data['voice'] = this.voice;
    data['question_picture_symbol'] = this.questionPictureSymbol;
    if (this.topic != null) {
      data['topic'] = this.topic!.toJson();
    }
    return data;
  }
}

class Topic {
  int? id;
  String? question;
  int? bookId;
  int? chapterId;
  String? createdAt;
  String? updatedAt;
  int? topicNo;
  String? topicPicture;
  String? extraPicture;
  String? topicVideo;

  Topic(
      {this.id,
      this.question,
      this.bookId,
      this.chapterId,
      this.createdAt,
      this.updatedAt,
      this.topicNo,
      this.topicPicture,
      this.extraPicture,
      this.topicVideo});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    bookId = json['book_id'];
    chapterId = json['chapter_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    topicNo = json['topic_no'];
    topicPicture = json['topic_picture'];
    extraPicture = json['extra_picture'];
    topicVideo = json['topic_video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['book_id'] = this.bookId;
    data['chapter_id'] = this.chapterId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['topic_no'] = this.topicNo;
    data['topic_picture'] = this.topicPicture;
    data['extra_picture'] = this.extraPicture;
    data['topic_video'] = this.topicVideo;
    return data;
  }
}
