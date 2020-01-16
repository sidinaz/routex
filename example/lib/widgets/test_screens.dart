import 'package:example/base/view.dart';
import 'package:example/config/config.dart';
import 'package:example/controllers/animation/data/animation_screen_type.dart';
import 'package:example/controllers/posts/view_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class TestStartScreen extends BaseView {
  final Config config;
  _TestStartScreenFields fields;

  TestStartScreen(this.config);

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text("Test for result",
                    style: Theme.of(context).textTheme.body1),
                  onPressed: () => RoutexNavigator.shared.push(
                    "/app/test/result", context, {"build_context": context}),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child:
                  Text("Log out", style: Theme.of(context).textTheme.body1),
                  onPressed: () => logoutAction(context),
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Choose posts screen type"),
                SizedBox(
                  height: 5,
                ),
                Observer(
                  stream: fields.postsScreenTypeSubject,
                  onSuccess: (ctx, type) => _typesSegmentedControl(type),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Choose animation screen type"),
                SizedBox(
                  height: 5,
                ),
                Observer(
                  stream: fields.animationScreenTypeSubject,
                  onSuccess: (ctx, type) => _animationTypesSegmentedControl(type),
                ),
                RaisedButton(
                  child:
                  Text("Animation screen", style: Theme.of(context).textTheme.body1),
                  onPressed: () => goToAnimationScreen(context),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void handleManagedFields() {
    fields = managedField(() => _TestStartScreenFields(config));
  }

  void logoutAction(BuildContext context) {
    RoutexNavigator.shared
        .pushReplacement("/app/main", context, {"user": null});
  }

  final _types = const <PostsScreenType, Widget>{
    PostsScreenType.withSlider: Padding(
      padding: EdgeInsets.all(5),
      child: Text('with Slider'),
    ),
    PostsScreenType.withScrolling: Padding(
      padding: EdgeInsets.all(5),
      child: Text('with Scrolling'),
    ),
  };

  final _animationTypes = const <AnimationScreenType, Widget>{
    AnimationScreenType.withTabs: Padding(
      padding: EdgeInsets.all(5),
      child: Text('Tabs'),
    ),
    AnimationScreenType.withStatefulWidget: Padding(
      padding: EdgeInsets.all(5),
      child: Text('Stateful'),
    ),
    AnimationScreenType.withHookWidget: Padding(
      padding: EdgeInsets.all(5),
      child: Text('Hook'),
    ),
  };

  Widget _typesSegmentedControl(PostsScreenType value) =>
      CupertinoSegmentedControl<PostsScreenType>(
        children: _types,
        onValueChanged: setPostsScreenType,
        groupValue: value,
        selectedColor: Color(0xFFf4b512),
        unselectedColor: Colors.white,
        borderColor: Color(0xFF2C3E50),
      );

  Widget _animationTypesSegmentedControl(AnimationScreenType value) =>
    CupertinoSegmentedControl<AnimationScreenType>(
      children: _animationTypes,
      onValueChanged: setAnimationScreenType,
      groupValue: value,
      selectedColor: Color(0xFFf4b512),
      unselectedColor: Colors.white,
      borderColor: Color(0xFF2C3E50),
    );

  void setPostsScreenType(PostsScreenType type) {
    fields.postsScreenTypeSubject.add(type);
    config.setPostsScreenType(type);
  }
  void setAnimationScreenType(AnimationScreenType type) {
    fields.animationScreenTypeSubject.add(type);
    config.setAnimationScreenType(type);
  }

  void goToAnimationScreen(BuildContext context) {
    if(config.animationScreenType == AnimationScreenType.withTabs){
      RoutexNavigator.shared.push("/app/animation/with-tabs", context);
    }else{
      RoutexNavigator.shared.push("/app/animation/", context);
    }
  }
}

class _TestStartScreenFields {
  // ignore: close_sinks
  final BehaviorSubject<PostsScreenType> postsScreenTypeSubject;
  final BehaviorSubject<AnimationScreenType> animationScreenTypeSubject;

  _TestStartScreenFields(Config config)
      : this.postsScreenTypeSubject = BehaviorSubject.seeded(config.postsScreenType),
       this.animationScreenTypeSubject = BehaviorSubject.seeded(config.animationScreenType);
}

class TestResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Success"),
        ),
        body: Center(
          child: Icon(Icons.done_outline,
              size: 50, color: Theme.of(context).primaryColor),
        ),
      );
}

class TestFailureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Failure, no result"),
        ),
        body: Center(
          child: Icon(
            Icons.remove_circle_outline,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
}

class TestClickForSuccessBackForFailureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Press or back"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text("Press for success or back for failure",
                  style: Theme.of(context).textTheme.body1),
              SizedBox(
                height: 50,
              ),
              RaisedButton(
                child: Text("Ok", style: Theme.of(context).textTheme.body1),
                onPressed: () => Navigator.pop(context, 200),
              )
            ])),
      );
}
