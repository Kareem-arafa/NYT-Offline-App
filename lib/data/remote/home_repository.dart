import 'dart:convert';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:nyt_offline_app/data/model/article_model.dart';
import 'package:nyt_offline_app/data/network_common.dart';
import 'package:nyt_offline_app/main.dart';
import 'package:nyt_offline_app/utils/shared_preferences_singleton.dart';

class HomeRepository {
  const HomeRepository();

  Future<List<ArticleModel>> getArticle() async {
    return NetworkCommon().dio.get(
      "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json",
      queryParameters: {
        "api-key": "sOsxUhhRy5Gn4FScudD84UxvIWPHKVVW",
      },
    ).then(
      (d) async {
        Map<String, dynamic> results = NetworkCommon().decodeResp(d);
        final List<ArticleModel> articles = (results['results'] as List).map((e) => ArticleModel.fromJson(e)).toList();
        FlutterIsolate.spawn(createBackup, results);
        //createBackup(articles);
        return articles;
      },
    );
  }

  Future<List<ArticleModel>> retrieveBackup() async {
    final SharedPreferencesManager preferencesManager = SharedPreferencesManager();
    final String data = preferencesManager.getString("backup_json") ?? "";
    if (data.isNotEmpty) {
      final json = jsonDecode(data);

      return (json['results'] as List).map((e) => ArticleModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
