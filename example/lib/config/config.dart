import 'package:example/controllers/posts/view_type.dart';

class Config{
  var _postsScreenType = PostsScreenType.withSlider;

  get postsScreenType => _postsScreenType;

  setPostsScreenType(value) {
    _postsScreenType = value;
  }
}