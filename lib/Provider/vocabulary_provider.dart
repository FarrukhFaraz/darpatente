import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/vocabulary_model.dart';
import '../Utils/url.dart';

class VocabularyProvider with ChangeNotifier {
  VocabularyModel _service;
  final BuildContext _context;

  List<String> _vocabularyWords = [];

  VocabularyProvider(this._service , this._context);

  Set<String> get vocabularyMap => _service.vocabularyMap;

  List<VocabularyModel> get vocabularyList => _service.vocabularyList;

  List<String> get vocabularyWords => _vocabularyWords;

  void _fetchWords(){
    for(String word in _service.vocabularyMap){
      _vocabularyWords.add(word);
    }
  }

  Future<void> fetchVocabulary() async {
    try {
      await _service.fetchVocabulary();
      _fetchWords();
    } catch (e) {
      print('Failed to fetch vocabulary in provider: $e');
    }
  }

  void cacheAllImage(List<String> imageList){
    for (var image in imageList) {
      var provider = CachedNetworkImageProvider('${imageBaseURL}topics/$image');
      provider.evict();
      provider.resolve(ImageConfiguration.empty);
    }
    print('all images are cached');
  }

  Future<void>fetchAllImage()async{
    Map body = {
      'cat_id': '',
    };
    print(body);

    try {
      http.Response response =
      await http.post(Uri.parse(allImagesURL), body: body);
      Map jsonData = jsonDecode(response.body);
      if(jsonData['status'] ==200){
        List<dynamic> topicImage = jsonData['topic'];
        List<String> imageList = [];

        for (var image in topicImage) {
          if (image != null) {
            imageList.add('${imageBaseURL}topics/$image');
          }
        }
        print('topic:::${imageList.length}');
        await cache(imageList);

        List<dynamic> chapterImage = jsonData['chapter'];
        List<String> chapterImageList = [];

        for (var image in chapterImage) {
          if (image != null) {
            chapterImageList.add('${imageBaseURL}chapters/$image');
          }
        }
        print('chapter:::${chapterImageList.length}');

        await cache(chapterImageList);
        print('all is fetched');
      }
    } catch (e) {
      print("excepiyon ::::$e");
    }
  }

  Future<void> cache(List<String> imageList)async {
    try {
      final futures = <Future>[];

      // Process images in subsets of 3
      for (int i = 0; i < imageList.length - 2; i += 3) {
        final subset = imageList.sublist(i, i + 3);
        final subsetFutures = subset.map((image) =>
            precacheImage(CachedNetworkImageProvider(image), _context));
        futures.addAll(subsetFutures);
      }

      final remainingImages = imageList.length % 3;
      if (remainingImages > 0) {
        final subset = imageList.sublist(imageList.length - remainingImages);
        final subsetFutures = subset.map((image) =>
            precacheImage(CachedNetworkImageProvider(image), _context));
        futures.addAll(subsetFutures);
      }

      await Future.wait(futures);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('allImages', 'ok');

    }catch(e){
      print('exception in caching:::::$e');
    }
  }

  Future<void> cacheTestImage(List<String> imageList)async{
    for (var image in imageList) {
      var provider = CachedNetworkImageProvider('${imageBaseURL}tests/$image');
      provider.evict();
      provider.resolve(ImageConfiguration.empty);
    }
    print('all images are cached');
  }

}
