import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

import '../basic_example.dart';
import '../examples_source.dart';


class ExamplesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Examples"),
      ),
      body: Observer<List<BasicExample>>(
        //FOR TESTING PURPOSES, EACH TIME CREATE NEW INSTANCE INSIDE BUILD METHOD
        stream: ExamplesSource.newInstance()(),//this return list of basicexample, and basicexample call() will return widgetbuilder for listview single item
        onSuccess: (ctx, examples) => ListView.builder(
          itemBuilder: (context, index) => examples[index]()(context),
          itemCount: examples.length,
        ),
      ),
    );
  }
}
