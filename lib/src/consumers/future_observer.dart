import 'dart:async';

import 'package:flutter/material.dart';
import 'package:routex/src/consumers/observer.dart';
import 'package:rxdart/rxdart.dart';

class FutureObserver<T> extends Observer<T>{
  FutureObserver({Function onError, Widget Function(BuildContext context,T data) onSuccess, Future<T> future, Function onWaiting})
      :super(onError: onError, onSuccess: onSuccess, stream:  Observable.fromFuture(future).shareValue(), onWaiting: onWaiting);
}
