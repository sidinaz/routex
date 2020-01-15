import 'package:example/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

import 'posts/posts_screen_with_slider.dart';

class PostsController implements BaseController {
  @override
  void bindRouter(Router router) {
    router.route("/app/posts/").handler(indexHandler);
  }

  WidgetBuilder indexHandler(RoutingContext context) =>
      (_) => context("PostsScreen");
}
