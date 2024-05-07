import 'package:nyt_offline_app/data/model/article_model.dart';

import '../action_report.dart';

class ArticlesStatusAction {
  final String actionName = "ArticlesStatusAction";
  final ActionReport report;

  ArticlesStatusAction({required this.report});
}

class GetArticlesAction {
  final String actionName = "GetArticlesAction";

  GetArticlesAction();
}

class GetBackupArticlesAction {
  final String actionName = "GetArticlesAction";

  GetBackupArticlesAction();
}

class SyncArticlesAction {
  final String actionName = "SyncArticlesAction";
  final List<ArticleModel> articles;

  SyncArticlesAction(this.articles);
}
