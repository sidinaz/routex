import 'package:example/controllers/animation/data/animation_mixin.dart';
import 'package:example/controllers/animation/data/animation_mixin_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// ignore: must_be_immutable
class AnimationScreenWithHookWidget extends HookWidget with AnimationMixin {
  @override
  Widget build(BuildContext context) {
    runHooks();
    return buildContent('Hook widget!');
  }

  void runHooks() {
    handleVariablesAssignement();
    useEffect(_lifecycleEvents, []);
  }

  void handleVariablesAssignement() {
    final boxController =
        useAnimationController(duration: Duration(milliseconds: 300));
    final catController =
        useAnimationController(duration: Duration(milliseconds: 200));
    fields =
        useMemoized(() => AnimationMixinFields(catController, boxController));
  }

  Dispose _lifecycleEvents() {
    componentDidMount();
    return componentWillUnmount;
  }

  void componentDidMount() {
    fields.boxAnimation.addStatusListener(fields.animationStatusListener);
    fields.boxController.forward();
  }

  void componentWillUnmount() {
    fields.boxAnimation.removeStatusListener(fields.animationStatusListener);
  }
}
