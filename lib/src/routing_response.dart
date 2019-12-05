import 'package:routex/routex.dart';

/// Represents routing response.
/// It allows the developer to control the response that is sent back to the client for a particular request.
abstract class RoutingResponse<T> {
  /// Ends the response.
  ///
  /// [model] is generic type, WidgetBuilder with [RoutexNavigator], String or any other type, identical to [RoutingRequest].
  void end(T model);

  bool ended();

  void fail(Object error);

  Future<T> materialize();
}
