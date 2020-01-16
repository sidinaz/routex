import 'package:example/controllers/animation/view/cat.dart';
import 'package:flutter/material.dart';

import 'animation_mixin_fields.dart';

mixin AnimationMixin {
  AnimationMixinFields fields;

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: fields.catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: fields.catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: fields.boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: fields.boxAnimation.value,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: fields.boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topRight,
            angle: -fields.boxAnimation.value,
          );
        },
      ),
    );
  }

  Widget buildContent(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void onTap() {
    if (fields.catController.status == AnimationStatus.completed) {
      fields.boxController.forward();
      fields.catController.reverse();
    } else if (fields.catController.status == AnimationStatus.dismissed) {
      fields.boxController.stop();
      fields.catController.forward();
    }
  }
}
