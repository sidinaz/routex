import 'package:example/controllers/posts/posts_view_model.dart';
import 'package:example/model/post_api.dart';
import 'package:rxdart/rxdart.dart';

class PostsManager {
  final _Sink sink;
  final PostsViewModel viewModel;

  PostsManager._(this.sink, this.viewModel);

  factory PostsManager.create(PostApi postApi) {
    print("Creating manager");
    var sink = _Sink();
    var viewModel = PostsViewModel.create(sink._page, postApi);
    return PostsManager._(sink, viewModel);
  }
}

class _Sink {
  // ignore: close_sinks
  final BehaviorSubject<int> _page = BehaviorSubject.seeded(0);

  void setPage(int value){
    _page.sink.add(value);
  }
}
