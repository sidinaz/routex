import 'package:flutter_test/flutter_test.dart';
import 'package:routex/routex.dart';

import 'util/test_util.dart';

void main() {
  test('Simple test', () async {
    var router = getRouter();

    router
      .route("/")
      .handler((context) => context.response().end("simple test"));

    expect(await testRequest("/"), "simple test");
  });

  test('Simple test 2', () async {
    var router = getRouter();

    var request = BaseRequest<String>("/");

    router
      .route("/")
      .handler((context) => context.response().end("ok"));

    expect(await testRequest(null, request), "ok");
  });

  test('Simple response code', () async {
    var router = getRouter();

    router
      .route("/")
      .handler((context) => context.response().end("ok"));

    expect(await testRequest("/", null, true), 200);
  });

}