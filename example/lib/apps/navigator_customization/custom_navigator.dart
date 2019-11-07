import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

class CustomNavigator extends RoutexNavigator {
  CustomNavigator([Router router])
      : super(router != null ? router : Router.router());

  @override
  Future<T> push<T extends Object>(String path, BuildContext context,
          [Map<String, dynamic> params]) =>
      Navigator.push(
        context,
        _pageRoute(builder: asWidgetBuilder(path, params)),
      );

  @override
  Future<T> pushReplacement<T extends Object>(String path, BuildContext context,
          [Map<String, dynamic> params]) =>
      Navigator.pushReplacement(
        context,
        _pageRoute(builder: asWidgetBuilder(path, params)),
      );

  @override
  Future<T> replaceRoot<T extends Object>(String path, BuildContext context,
          [Map<String, dynamic> params]) =>
      Navigator.pushAndRemoveUntil(
        context,
        _pageRoute(builder: asWidgetBuilder(path, params)),
        (_) => false,
      );

  PageRoute<T> _pageRoute<T>({@required WidgetBuilder builder}) =>
      Platform.isIOS
          ? CupertinoPageRoute(builder: builder)
          : MaterialPageRoute(builder: builder);
}
