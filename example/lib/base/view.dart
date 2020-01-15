import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:routex/routex.dart';
import 'package:rxdart/rxdart.dart';

import 'view_model.dart';

// ignore: must_be_immutable
abstract class BaseView<T extends BaseViewModel> extends HookWidget {
  ValueNotifier<int> stateTrigger;
  T model;
  _Fields managedFields;

  CompositeSubscription get disposeBag => managedFields.disposeBag;

  Mounted get mounted => managedFields.mounted;

  get managedField => useMemoized;

  BaseView({Key key}) : super(key: key);

  ///use [buildWidget] method instead [build]]
  Widget buildWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    runHooks();
    return buildWidget(context);
  }

  WidgetBuilder managedView(String path, [Map<String, dynamic> params]) =>
      managedFields.managedViews[path] ??= RoutexNavigator.shared.get(path, params);

  //explicitly update state when working with non reactive data
  void setState([VoidCallback fn]) {
    if (fn != null) fn();
    ++stateTrigger.value;
  }

  /// https://reactjs.org/docs/hooks-effect.html
  @mustCallSuper
  void runHooks() {
    _handleManagedFields();
    useEffect(_handleLifecycleEvents, []);
  }

  void _handleManagedFields() {
    stateTrigger = useState(0);
    managedFields = managedField(() => _Fields());
    handleManagedFields();
  }

  void _componentDidMount() {
    if (model != null) {
      model.start();
    }
    mounted.setIsMounted(true);
    componentDidMount();
  }

  void _componentWillUnmount() {
    if (model != null) {
      model.dispose();
    }
    mounted.setIsMounted(false);
    disposeBag.clear();
    componentWillUnmount();
    print("componentWillUnmount ${this.toString()}");
  }

  Dispose _handleLifecycleEvents() {
    _componentDidMount();
    return _componentWillUnmount;
  }

  //
  void handleManagedFields() {}

  void componentDidMount() {}

  void componentWillUnmount() {}
}

class Mounted {
  bool isMounted = false;

  void setIsMounted(bool mounted) => isMounted = mounted;

  bool call() => isMounted;
}

class _Fields<T extends BaseViewModel> {
  final CompositeSubscription disposeBag = CompositeSubscription();
  final Map<String, WidgetBuilder> managedViews = Map();
  final Mounted mounted = Mounted();
}
