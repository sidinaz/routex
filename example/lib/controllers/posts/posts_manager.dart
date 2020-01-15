import 'package:example/controllers/posts/posts_view_model.dart';
import 'package:example/model/post_api.dart';
import 'package:rxdart/rxdart.dart';

class PostsManager {
  final _Sink sink;
  final PostsViewModel viewModel;

  PostsManager._(this.sink, this.viewModel);

  factory PostsManager.create(PostApi postApi) {
    var sink = _Sink();
    var viewModel = PostsViewModel.create(sink._page, sink._rowIndex, postApi);
    return PostsManager._(sink, viewModel);
  }
}

class _Sink {
  // ignore: close_sinks
  final BehaviorSubject<int> _page = BehaviorSubject();
  final BehaviorSubject<int> _rowIndex = BehaviorSubject.seeded(-1);

  void addPage(double value) => _page.add(value.toInt());

  void addRowIndex(int value) => _rowIndex.add(value);
}
