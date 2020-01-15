import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


extension RowsToPageReducer on Stream<int> {
  Stream<int> getNewPageFromRowIndex({
    @required int itemsPerPage,
    int initialValue = 0,
  }) =>
      map((ri) => ri != -1 ? (ri + 1) ~/ itemsPerPage : 0)
          .scan((int a, c, i) => c != -1 ? c > a ? c : a : 0, initialValue)
          .distinct();
}
