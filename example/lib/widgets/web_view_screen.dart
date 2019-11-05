import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

class WebViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebViewScreen"),
      ),
      body: Container(
        child: RaisedButton(onPressed: () => RoutexNavigator.shared.push("/v1/foo2", context),),
      ),
    );
  }
}
