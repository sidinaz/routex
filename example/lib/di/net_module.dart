import 'package:daggerito/daggerito.dart';
import 'package:dio/dio.dart';
import 'package:example/model/dio_client.dart';

class NetModule implements Module {
  @override
  void register(DependencyContainer container) {
    container.register(
      (_) => provideCustomInterceptor(),
      tag: "custom_interceptor",
    );

    container
        .register((_) => LogInterceptor(responseBody: false) as Interceptor);

    container.register(($) => provideDio($(), $("custom_interceptor")));

    container.register(($) => DioClient($()));
  }

  Dio provideDio(
    Interceptor logInterceptor,
    Interceptor customInterceptor,
  ) =>
      Dio()
        ..options.baseUrl = "http://jsonplaceholder.typicode.com"
        ..options.connectTimeout = 300
        ..options.receiveTimeout = 500
        ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
        ..interceptors.add(logInterceptor)
        ..interceptors.add(customInterceptor);

  Interceptor provideCustomInterceptor() => InterceptorsWrapper(
        onRequest: (Options options) async =>
            print("Calling customInterceptor"),
      );
}
