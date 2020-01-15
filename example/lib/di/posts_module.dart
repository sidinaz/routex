import 'package:daggerito/daggerito.dart';
import 'package:example/config/config.dart';
import 'package:example/controllers/posts/posts_manager.dart';
import 'package:example/controllers/posts/posts_screen_with_scrolling.dart';
import 'package:example/controllers/posts/posts_screen_with_slider.dart';
import 'package:example/controllers/posts/view_type.dart';
import 'package:flutter/cupertino.dart';

class PostsModule implements Module {
  @override
  void register(DependencyContainer container) {
    container.register(($) => PostsManager.create($()));
    container.register(providePostsScreen, tag: "PostsScreen");
  }

  Widget providePostsScreen(DependencyContainer $) =>
      $<Config>().postsScreenType == PostsScreenType.withScrolling
          ? PostsScreenWithScrolling($())
          : PostsScreenWithSlider($());
}
