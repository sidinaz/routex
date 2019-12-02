import 'package:example/di/posts_component.dart';
import 'package:example/di/posts_module.dart';
import 'package:example/di/user_component.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

import 'posts/posts_screen.dart';

class PostsController implements Controller {
  @override
  void bindRouter(Router router) {
    router
      .route("/app/posts/*")
    .handler(log);
    router
      .route("/app/posts/")
      .handler(indexHandler);

//    router
//      .route("/app/country-details")
  }

  void log(RoutingContext context){
print("Objekat neki");
    context.next();
  }

  WidgetBuilder indexHandler(RoutingContext context){
    var component = PostsComponent(context.get<UserComponent>(UserComponent.key), PostsModule());
    var manager = component.getPostsManager();
    print("Ispod je posts api");
    print(manager);

    return (bc) => _template(
      "Posts",
      PostsScreen(manager),
    );
  }

  Widget _template(String title, Widget content) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: content,
      );
}
