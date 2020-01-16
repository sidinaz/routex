import 'package:example/base/base_controller.dart';
import 'package:example/di/animation_component.dart';
import 'package:example/di/countries_component.dart';
import 'package:example/di/posts_component.dart';
import 'package:example/di/user_component.dart';
import 'package:example/handlers/create_component_handler.dart';
import 'package:routex/routex.dart';

class InjectComponentsController implements BaseController {
  @override
  void bindRouter(Router router) {
    router
        .routeWithRegex(r"^(\/v1)?\/app/*")
        .handler(_createUserComponentHandler());

    router.route("/app/posts/*").handler(_createPostsComponentHandler());
    router
        .route("/app/animation/*")
        .handler(_createAnimationComponentHandler());

    router
        .routeWithRegex(r"^(\/v1)?\/app/countries/*")
        .handler(_createCountriesComponentHandler());
  }
}

_createUserComponentHandler() => CreateComponentHandler(
      // use context to take any data needed for creation of scoped components
      factory: (context) async => context.get<UserComponent>(UserComponent.key),
    );

_createPostsComponentHandler() => CreateComponentHandler(
      // use context to take any data needed for creation of scoped components
      factory: (context) async =>
          PostsComponent(context.get(UserComponent.key)),
    );

_createCountriesComponentHandler() => CreateComponentHandler(
      factory: (context) async =>
          CountriesComponent(context.get(UserComponent.key)),
    );

_createAnimationComponentHandler() => CreateComponentHandler(
      // use context to take any data needed for creation of scoped components
      factory: (context) async => AnimationComponent(
        context.get(UserComponent.key),
        context.getParam("type"),
      ),
    );
