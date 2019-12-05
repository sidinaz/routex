import 'package:routex/src/content_type.dart';
import 'package:routex/src/impl/routing_response_impl.dart';

/// Represents routing request.
abstract class RoutingRequest<T> {
  String path();

  BaseResponse<T> response();

  Map<String, dynamic> params();

  ContentType content();
}
