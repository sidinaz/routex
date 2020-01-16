import 'package:daggerito/daggerito.dart';
import 'package:example/controllers/animation/animation_module.dart';
import 'package:example/controllers/animation/data/animation_screen_type.dart';

import 'user_component.dart';

class AnimationComponent extends SubComponent {
  AnimationComponent(UserComponent userComponent,
      [AnimationScreenType animationScreenType])
      : super(
          [userComponent],
          modules: [
            AnimationModule(animationScreenType),
          ],
        );
}
