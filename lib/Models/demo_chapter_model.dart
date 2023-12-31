class DemoMainCategoryModel {
  int? id;
  String? name;
  String? description;
  String? link;
  String? createdAt;
  String? updatedAt;
  int? categoryId;

  DemoMainCategoryModel(
      {this.id,
      this.name,
      this.description,
      this.link,
      this.createdAt,
      this.updatedAt,
      this.categoryId});

  DemoMainCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    link = json['link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['link'] = this.link;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_id'] = this.categoryId;
    return data;
  }
}
