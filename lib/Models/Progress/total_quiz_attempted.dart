class TotalQuizAttemptedModel {
  String? quizeId;
  String? updatedAt;

  TotalQuizAttemptedModel({this.quizeId, this.updatedAt});

  TotalQuizAttemptedModel.fromJson(Map<String, dynamic> json) {
    quizeId = json['quize_id'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quize_id'] = this.quizeId;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
