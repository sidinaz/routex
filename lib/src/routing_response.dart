abstract class RoutingResponse<T> {
  void end(T model);

  bool ended();

  void fail(Object error);

  Future<T> materialize();
}