import 'package:example/base/rows_to_page_reducer.dart';
import 'package:example/base/view_model.dart';
import 'package:example/model/post.dart';
import 'package:example/model/post_api.dart';
import 'package:example/model/post_list.dart';
import 'package:rxdart/rxdart.dart';

//
class PostsViewModel extends BaseViewModel {
  static const int ItemsPerPage = 10;
  final Stream<PostsList> _postsStream;
  final BehaviorSubject<List<Post>> _postsSubject;
  final Stream<int> currentPage;

  get posts => _postsSubject;

  PostsViewModel._(this._postsStream, this._postsSubject, this.currentPage);

  factory PostsViewModel.create(
    Stream<int> page,
    Stream<int> rowIndex,
    PostApi postApi,
  ) {
    // ignore: close_sinks
    final postSubject = BehaviorSubject<List<Post>>.seeded([]);
    //support for changing page with slider value or with scrolling list by changing row index
    final _page = Rx.merge([
      page.debounce(
          (_) => TimerStream(true, const Duration(milliseconds: 200)))
      .distinct()
      .doOnData((_) => postSubject.value = []),
      rowIndex.getNewPageFromRowIndex(
        itemsPerPage: ItemsPerPage,
        initialValue: postSubject.value.length ~/ ItemsPerPage,
      ),
    ]).shareValue();

    final postsStream = _page
        .flatMap((page) => postApi.getPostsByPage(page).asStream());

    return PostsViewModel._(postsStream, postSubject, _page);
  }

  @override
  void start() {
    disposeBag.add(_postsStream.listen(setItems));
  }

  void setItems(PostsList postsList) {
    this._postsSubject.add([...this._postsSubject.value, ...postsList()]);
  }
}
