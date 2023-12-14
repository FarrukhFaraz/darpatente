import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Utils/url.dart';

class VocabularyModel {
  int? id;
  String? word;
  String? meaning;
  String? urdu;
  String? hindi;
  String? punjabi;
  String? bangali;
  String? forsi;
  String? picture;
  String? createdAt;
  String? updatedAt;

  final Set<String> _vocabularyMap = {};

  final List<VocabularyModel> _vocabularyList = [];

  Set<String> get vocabularyMap => _vocabularyMap;

  List<VocabularyModel> get vocabularyList => _vocabularyList;

  VocabularyModel(
      {this.id,
      this.word,
      this.meaning,
      this.urdu,
      this.hindi,
      this.punjabi,
      this.bangali,
      this.forsi,
      this.picture,
      this.createdAt,
      this.updatedAt});

  VocabularyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    word = json['word'];
    meaning = json['meaning'];
    urdu = json['urdu'];
    hindi = json['hindi'];
    punjabi = json['punjabi'];
    bangali = json['bangali'];
    forsi = json['forsi'];
    picture = json['picture'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['word'] = this.word;
    data['meaning'] = this.meaning;
    data['urdu'] = this.urdu;
    data['hindi'] = this.hindi;
    data['punjabi'] = this.punjabi;
    data['bangali'] = this.bangali;
    data['forsi'] = this.forsi;
    data['picture'] = this.picture;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  Future<void> fetchVocabulary() async {
    try {
      http.Response response = await http.get(Uri.parse(getVocabularyURL));

      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (int i = 0; i < jsonData.length; i++) {
          VocabularyModel pos = VocabularyModel();
          pos = VocabularyModel.fromJson(jsonData[i]);
          _vocabularyMap.add(pos.word.toString());
          vocabularyList.add(pos);
        }
      }
      print(_vocabularyMap.length);
    } catch (e) {
      print(e);
    }
  }
}
