import 'package:nyt_offline_app/redux/articles/articles_reducer.dart';

import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    articlesState: articlesReducer(state.articlesState, action),
  );
}
