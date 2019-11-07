import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

class CustomErrorScreen extends StatelessWidget {
  final ResponseStatusException error;

  CustomErrorScreen(Object object): this.error = object is  ResponseStatusException ? object : ResponseStatusException(500, object);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        "${error.statusCode}",
      ),
    ),
    body: Container(
      color: Colors.redAccent,
      child: Center(
        child: Text(error.toString(),
          style: Theme.of(context).textTheme.title),
      ),
    ),
  );
}