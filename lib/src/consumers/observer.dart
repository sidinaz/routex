import 'dart:async';

import 'package:flutter/material.dart';

class Observer<T> extends StatelessWidget {
  @required
  final Stream<T> stream;

  @required
  final Widget Function(BuildContext context, T data) onSuccess;

  final Function onError;
  final Function onWaiting;

  const Observer({this.onError, this.onSuccess, this.stream, this.onWaiting});

  Function get _defaultOnWaiting => (context) => Container();

  Function get _defaultOnError => (context, error) {
        return Text(error);
      };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return (onError != null)
              ? onError(context, snapshot.error.toString())
              : _defaultOnError(context, snapshot.error.toString());
        }

        if (snapshot.hasData) {
          T data = snapshot.data;
          return onSuccess(context, data);
        } else {
          return (onWaiting != null)
              ? onWaiting(context)
              : _defaultOnWaiting(context);
        }
      },
    );
  }
}
