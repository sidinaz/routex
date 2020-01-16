import 'dart:math';

import 'package:flutter/material.dart';

class AnimationMixinFields {
  final Animation<double> catAnimation;
  final AnimationController catController;
  final Animation<double> boxAnimation;
  final AnimationController boxController;
  final AnimationStatusListener animationStatusListener;

  AnimationMixinFields._(this.catAnimation, this.catController,
      this.boxAnimation, this.boxController, this.animationStatusListener);

  factory AnimationMixinFields(
      AnimationController catController, AnimationController boxController) {
    final boxAnimation = Tween(
      begin: pi * 0.6,
      end: pi * 0.65,
    ).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOut,
      ),
    );

    final catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );

    final AnimationStatusListener animationStatusListener = (status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    };

    return AnimationMixinFields._(catAnimation, catController, boxAnimation,
        boxController, animationStatusListener);
  }
}
