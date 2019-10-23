import 'package:flutter/material.dart';

class IrresponsibleRequestWidget extends StatelessWidget {
  final Object error;

  IrresponsibleRequestWidget(this.error);

  @override
  Widget build(BuildContext context) {
    return           Card(
      color: Theme.of(context).primaryColor,
      child: ListTile(
        title: Column(
          children: <Widget>[
            Text(error.toString()),
            Text("Context neither complete or fails. (Missing context.next() or context.fail(error) call.)"),
          ],
        ),//Context neither complete or fails. (Missing context.next() or context.fail(error) call.)
        trailing: Icon(error != null ? Icons.remove_circle_outline : Icons.done_outline),
      ),
    );
  }
}