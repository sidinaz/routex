import 'package:daggerito/daggerito.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

class CreateComponentHandler<T extends Component>
    implements Handler<RoutingContext> {
  static const key = "component";
  final Future<T> Function(RoutingContext) factory;

  CreateComponentHandler({@required this.factory});

  @override
  Future<void> handle(RoutingContext context) async =>
      context.put(key, await factory(context)).next();
}

extension UseComponentAsHandler<T extends Component> on T {
  CreateComponentHandler asHandler() =>
      CreateComponentHandler(factory: (_) async => this);
}
