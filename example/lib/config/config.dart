import 'package:example/controllers/animation/data/animation_screen_type.dart';
import 'package:example/controllers/posts/view_type.dart';

class Config {
  var _postsScreenType = PostsScreenType.withSlider;
  var _animationScreenType = AnimationScreenType.withStatefulWidget;

  get postsScreenType => _postsScreenType;

  get animationScreenType => _animationScreenType;

  setPostsScreenType(value) {
    _postsScreenType = value;
  }

  setAnimationScreenType(value) {
    _animationScreenType = value;
  }
}
