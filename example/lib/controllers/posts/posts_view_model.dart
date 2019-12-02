import 'package:example/model/post_api.dart';
import 'package:example/model/post_list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
//
class PostsViewModel {
  final Observable<Tuple2<bool, PostsList>> Function() isLoading_PostsList$;
  CompositeSubscription compositeSubscription = CompositeSubscription();

  PostsViewModel._(this.isLoading_PostsList$);

  factory PostsViewModel.create(
    Observable<int> page,
    PostApi postApi,
  ) {
    // ignore: close_sinks
    var isLoading = BehaviorSubject.seeded(false);

    Observable<Tuple2<bool, PostsList>> Function() isLoading_PostsList$ =
    () =>         Observable.combineLatest2(
      isLoading
        .distinct(),
      page
        .distinct()
        .throttle((_) => TimerStream(true, const Duration(milliseconds: 500)))
        .doOnData((_) => isLoading.value = true)
        .flatMap(
          (page) => Observable.fromFuture(postApi.getPostsByPage(page)))
        .doOnEach((_) => isLoading.value = false),
        (e, p) => Tuple2(e, p),
    );
    return PostsViewModel._(isLoading_PostsList$);
  }

  void dispose() {
    compositeSubscription = CompositeSubscription();
  }
}
