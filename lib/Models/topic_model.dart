class TopicsModel {
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

  TopicsModel(
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

  TopicsModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['book_id'] = bookId;
    data['chapter_id'] = chapterId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['topic_no'] = topicNo;
    data['topic_picture'] = topicPicture;
    data['extra_picture'] = extraPicture;
    data['topic_video'] = topicVideo;
    return data;
  }
}