import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nyt_offline_app/data/model/article_model.dart';
import 'package:nyt_offline_app/features/article_view_model.dart';
import 'package:nyt_offline_app/features/cached_web_view.dart';
import 'package:nyt_offline_app/features/web_view.dart';
import 'package:nyt_offline_app/redux/action_report.dart';
import 'package:nyt_offline_app/redux/app/app_state.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:nyt_offline_app/utils/conntection_controller.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ArticlesViewModel>(
      distinct: true,
      converter: (store) => ArticlesViewModel.fromStore(store),
      builder: (_, viewModel) => _ArticlesScreenContent(
        viewModel: viewModel,
      ),
    );
  }
}

class _ArticlesScreenContent extends StatefulWidget {
  final ArticlesViewModel viewModel;

  const _ArticlesScreenContent({required this.viewModel});

  @override
  State<_ArticlesScreenContent> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<_ArticlesScreenContent> {
  StreamSubscription? _connectionChangeStream;

  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    ConnectivityController connectionStatus = ConnectivityController.getInstance();
    if (connectionStatus.isConnected) {
      widget.viewModel.getArticles();
    } else {
      widget.viewModel.getBackupArticles();
    }
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic isConnected) {
    setState(() {
      isOffline = !isConnected;
    });
    if (isOffline) {
      widget.viewModel.getBackupArticles();
    } else {
      widget.viewModel.getArticles();
    }
  }

  @override
  void dispose() {
    super.dispose();
    ConnectivityController.getInstance().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SafeArea(
          child: widget.viewModel.getArticlesReport.status == ActionStatus.running
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    !isOffline
                        ? const SizedBox.shrink()
                        : Container(
                            height: 40,
                            width: double.infinity,
                            color: Colors.red,
                            child: const Center(
                              child: Text(
                                "No Internet Connection",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final ArticleModel articleModel = widget.viewModel.articles[index];
                            return ArticleItem(
                              articleModel: articleModel,
                              isOffline: isOffline,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: widget.viewModel.articles.length,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    if (isOffline) {
      widget.viewModel.getBackupArticles();
    } else {
      widget.viewModel.getArticles();
    }
  }
}

class ArticleItem extends StatelessWidget {
  final ArticleModel articleModel;
  final bool isOffline;

  const ArticleItem({super.key, required this.articleModel, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isOffline) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CachedWebView(url: articleModel.htmlPath ?? ""),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebView(url: articleModel.url ?? ""),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.black54)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isOffline
                    ? Image.file(
                        File(articleModel.imagePath ?? ""),
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        articleModel.media?.first.mediaMetadata?.last.url ?? "",
                        fit: BoxFit.cover,
                      ),
              ),
              Text(
                articleModel.title ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(articleModel.abstract ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
