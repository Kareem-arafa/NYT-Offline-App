import 'package:nyt_offline_app/data/model/article_model.dart';
import 'package:nyt_offline_app/redux/action_report.dart';
import 'package:nyt_offline_app/redux/app/app_state.dart';
import 'package:nyt_offline_app/redux/articles/articles_actions.dart';
import 'package:redux/redux.dart';

class ArticlesViewModel {
  final List<ArticleModel> articles;

  final Function() getArticles;
  final Function() getBackupArticles;

  final ActionReport getArticlesReport;

  ArticlesViewModel({
    required this.articles,
    required this.getArticles,
    required this.getArticlesReport,
    required this.getBackupArticles,
  });

  static ArticlesViewModel fromStore(Store<AppState> store) {
    return ArticlesViewModel(
      articles: store.state.articlesState.articles.values.toList(),
      getArticles: () {
        store.dispatch(GetArticlesAction());
      },
      getBackupArticles: () {
        store.dispatch(GetBackupArticlesAction());
      },
      getArticlesReport: store.state.articlesState.status['GetArticlesAction'] ?? ActionReport(),
    );
  }
}
