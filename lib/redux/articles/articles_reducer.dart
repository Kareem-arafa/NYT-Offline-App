import 'package:redux/redux.dart';

import 'articles_actions.dart';
import 'articles_state.dart';

final articlesReducer = combineReducers<ArticlesState>([
  TypedReducer<ArticlesState, ArticlesStatusAction>(_syncArticlesState).call,
  TypedReducer<ArticlesState, SyncArticlesAction>(_syncArticles).call,
]);

ArticlesState _syncArticlesState(ArticlesState state, ArticlesStatusAction action) {
  var status = state.status;
  status.update(action.report.actionName!, (v) => action.report, ifAbsent: () => action.report);

  return state.copyWith(status: status);
}

ArticlesState _syncArticles(ArticlesState state, SyncArticlesAction action) {
  for (var article in action.articles) {
    state.articles.update(article.id.toString(), (value) => article, ifAbsent: () => article);
  }
  return state.copyWith(articles: state.articles);
}
