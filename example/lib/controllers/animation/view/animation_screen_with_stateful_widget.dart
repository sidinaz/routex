import 'package:example/controllers/animation/data/animation_mixin.dart';
import 'package:example/controllers/animation/data/animation_mixin_fields.dart';
import 'package:flutter/material.dart';

class AnimationScreenWithStatefulWidget extends StatefulWidget {
  AnimationScreenWithStatefulWidgetState createState() =>
      AnimationScreenWithStatefulWidgetState();
}

class AnimationScreenWithStatefulWidgetState
    extends State<AnimationScreenWithStatefulWidget>
    with TickerProviderStateMixin, AnimationMixin {
  Widget build(context) {
    return buildContent('Stateful widget!');
  }

  initState() {
    super.initState();

    final boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    final catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    fields = AnimationMixinFields(catController, boxController);
    fields.boxAnimation.addStatusListener(fields.animationStatusListener);
    fields.boxController.forward();
  }

  @override
  void dispose() {
    fields.boxController.dispose();
    fields.catController.dispose();
    super.dispose();
  }
}
