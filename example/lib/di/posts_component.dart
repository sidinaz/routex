import 'package:daggerito/daggerito.dart';
import 'package:example/controllers/posts/posts_manager.dart';

import 'posts_module.dart';
import 'user_component.dart';

class PostsComponent extends SubComponent {
  PostsComponent(
    UserComponent userComponent,
  ) : super(
          [userComponent],
          modules: [PostsModule()],
        );
}
