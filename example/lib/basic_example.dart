import 'package:flutter/material.dart';

import 'widgets/irresponsible_request_widget.dart';

class BasicExample {
  final Object response;
  final Object error;
  final Widget widget;

  bool get hasError => error != null;

  BasicExample({this.response, this.error, this.widget});

  WidgetBuilder call() {
    if (response is WidgetBuilder) {
      return response as WidgetBuilder;
    }
    if (response is String) {
      return (ctx) =>
          Card(
          color: Theme.of(ctx).primaryColor,
            child: ListTile(
              title: Text(response.toString()),
              trailing: Icon(error != null ? Icons.remove_circle_outline : Icons.done_outline),
            ),
          );
    }
    if (hasError) {
      return widget != null
          ? (ctx) => widget
          : (ctx) =>           Card(
        color: Theme.of(ctx).primaryColor,
        child: ListTile(
          title: Text(error.toString()),
          trailing: Icon(error != null ? Icons.remove_circle_outline : Icons.done_outline),
        ),
      );
    }

    return (ctx) => Text("empty");
  }

  BasicExample.withResponse(Object response) : this(response: response);

  BasicExample.withError(Object error) : this(error: error);
}

class Example extends BasicExample {
  Example.irresponsibleRequest(Object error)
      : super(error: error, widget: IrresponsibleRequestWidget(error));
}


