import 'package:nyt_offline_app/data/remote/home_repository.dart';
import 'package:nyt_offline_app/redux/app/app_state.dart';
import 'package:nyt_offline_app/redux/articles/articles_actions.dart';
import 'package:redux/redux.dart';

import '../action_report.dart';

List<Middleware<AppState>> createArticlesMiddleware([
  HomeRepository repository = const HomeRepository(),
]) {
  final getArticles = _getArticles(repository);
  final getBackupArticles = _getBackupArticles(repository);

  return [
    TypedMiddleware<AppState, GetArticlesAction>(getArticles).call,
    TypedMiddleware<AppState, GetBackupArticlesAction>(getBackupArticles).call,
  ];
}

Middleware<AppState> _getArticles(HomeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    store.state.articlesState.articles.clear();
    repository.getArticle().then((articles) {
      completed(next, action);
      next(SyncArticlesAction(articles));
    }).catchError((error) {
      catchError(next, action, error.toString());
    });
  };
}

Middleware<AppState> _getBackupArticles(HomeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    store.state.articlesState.articles.clear();
    repository.retrieveBackup().then((articles) {
      completed(next, action);
      next(SyncArticlesAction(articles));
    }).catchError((error) {
      catchError(next, action, error.toString());
    });
  };
}

void catchError(NextDispatcher next, action, error) {
  next(ArticlesStatusAction(
      report: ActionReport(actionName: action.actionName, status: ActionStatus.error, msg: error.toString())));
}

void completed(NextDispatcher next, action) {
  next(ArticlesStatusAction(
      report: ActionReport(
          actionName: action.actionName, status: ActionStatus.complete, msg: "${action.actionName} is completed")));
}

void running(NextDispatcher next, action) {
  next(ArticlesStatusAction(
      report: ActionReport(
          actionName: action.actionName, status: ActionStatus.running, msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(ArticlesStatusAction(
      report: ActionReport(actionName: action.actionName, status: ActionStatus.error, msg: "Id is empty")));
}
