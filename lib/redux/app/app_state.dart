import 'package:nyt_offline_app/redux/articles/articles_state.dart';

class AppState {
  final ArticlesState articlesState;

  AppState({
    required this.articlesState,
  });

  factory AppState.initial() {
    return AppState(
      articlesState: ArticlesState.initial(),
    );
  }
}
