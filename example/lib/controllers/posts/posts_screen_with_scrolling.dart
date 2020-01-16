import 'package:example/controllers/posts/posts_manager.dart';
import 'package:example/controllers/posts/posts_screen_with_slider.dart';
import 'package:example/model/post.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PostsScreenWithScrolling extends PostsScreenWithSlider {
  @override
  final String title = "Posts with scrolling";
  PostsScreenWithScrolling(PostsManager manager) : super(manager);

  @override
  Widget buildTopControl() => Container();

  @override
  Widget buildItem(Post model, int index) {
    sink.addRowIndex(index);
    return super.buildItem(model, index);
  }
}
