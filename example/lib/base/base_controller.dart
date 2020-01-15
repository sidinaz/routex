import 'package:example/handlers/create_component_handler.dart';
import 'package:routex/routex.dart';

abstract class BaseController implements Controller {}

//helper to speed up container calls
extension GetCreatedComponent on RoutingContext {
  T call<T>([String tag]) {
    T object = get(CreateComponentHandler.key).container.resolve<T>(tag);
    assert(object != null, """
        "Missing definition for $T type, check module for definitions and ensure that provided component contains that module
         or collaborates with component that contains it. ${this.normalisedPath()}"
        """);
    return object;
  }
}