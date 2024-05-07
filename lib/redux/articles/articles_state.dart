import 'package:nyt_offline_app/data/model/article_model.dart';

import '../action_report.dart';

class ArticlesState {
  final Map<String, ActionReport> status;
  final Map<String, ArticleModel> articles;

  ArticlesState({
    required this.status,
    required this.articles,
  });

  factory ArticlesState.initial() {
    return ArticlesState(
      status: <String, ActionReport>{},
      articles: <String, ArticleModel>{},
    );
  }

  ArticlesState copyWith({
    Map<String, ActionReport>? status,
    Map<String, ArticleModel>? articles,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
    );
  }
}
