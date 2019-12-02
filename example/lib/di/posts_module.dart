import 'package:daggerito/daggerito.dart';
import 'package:example/controllers/posts/posts_manager.dart';

class PostsModule implements Module {
  @override
  void register(DependencyContainer container) {
    container.register(($) => PostsManager.create($()));
  }
}
