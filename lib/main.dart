import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nyt_offline_app/features/articles_screen.dart';
import 'package:nyt_offline_app/redux/app/app_state.dart';
import 'package:nyt_offline_app/redux/store.dart';
import 'package:nyt_offline_app/utils/conntection_controller.dart';
import 'package:nyt_offline_app/utils/shared_preferences_singleton.dart';
import 'package:nyt_offline_app/utils/toast_utils.dart';
import 'package:redux/redux.dart';

import 'data/model/article_model.dart';

@pragma('vm:entry-point')
void createBackup(Map<String, dynamic> articles) async {
  final List<ArticleModel> results = (articles['results'] as List).map((e) => ArticleModel.fromJson(e)).toList();
  for (var article in results) {
    //Caching to article images
    final String url = article.media?.first.mediaMetadata?.last.url ?? "";
    final file = await DefaultCacheManager().getSingleFile(url);
    article.imagePath = file.path;

    //Caching to article URL
    DefaultCacheManager cacheManager = DefaultCacheManager();

    FileInfo? fileInfo = await cacheManager.getFileFromCache(article.url ?? "");

    if (fileInfo != null) {
      article.htmlPath = fileInfo.file.path;
    } else {
      final fileData = await cacheManager.downloadFile(article.url ?? "");
      article.htmlPath = fileData.file.path;
    }
  }
  //Caching to article object in sharedPreferences
  final Map<String, dynamic> map = {"results": results.map((e) => e.toJson()).toList()};
  final SharedPreferencesManager preferencesManager = SharedPreferencesManager();
  await preferencesManager.init();
  final String data = jsonEncode(map);
  preferencesManager.setString("backup_json", data);

  //Success Message
  showToast("Backup Stored");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var store = await createStore();
  final ConnectivityController connectionStatus = ConnectivityController.getInstance();
  connectionStatus.init();
  SharedPreferencesManager sharedPreferencesManager = SharedPreferencesManager();
  await sharedPreferencesManager.init();
  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'New York Times',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const ArticlesScreen(),
      ),
    );
  }
}
