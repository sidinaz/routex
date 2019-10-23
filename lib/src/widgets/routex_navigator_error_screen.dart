import 'package:flutter/material.dart';
import 'package:routex/src/exceptions/response_status_exception.dart';

class RoutexNavigatorErrorScreen extends StatelessWidget {
  final ResponseStatusException error;

  RoutexNavigatorErrorScreen(this.error);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(error.toString(),),
      ),
      body: Container(
        color: Colors.greenAccent,
        child: Center(
          child: Text(error.toString(), style: Theme
            .of(context)
            .textTheme
            .title),
        ),
      ),
    );
  }
}
