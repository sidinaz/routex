import 'package:daggerito/daggerito.dart';
import 'package:example/config/config.dart';
import 'package:example/controllers/animation/data/animation_screen_type.dart';
import 'package:example/controllers/animation/view/animation_screen_with_hook_widget.dart';
import 'package:example/controllers/animation/view/animation_screen_with_stateful_widget.dart';
import 'package:flutter/material.dart';

class AnimationModule implements Module {
  final AnimationScreenType animationScreenType;

  AnimationModule([this.animationScreenType]);

  @override
  void register(DependencyContainer container) {
    container.register(provideAnimationScreen, tag: "AnimationScreen");
  }

  Widget provideAnimationScreen(DependencyContainer $) {
    switch (animationScreenType ?? $<Config>().animationScreenType) {
      case AnimationScreenType.withStatefulWidget:
        return AnimationScreenWithStatefulWidget();
      case AnimationScreenType.withHookWidget:
        return AnimationScreenWithHookWidget();
      default:
        return AnimationScreenWithHookWidget();
    }
  }
}
