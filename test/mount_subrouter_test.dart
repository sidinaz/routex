import 'package:flutter_test/flutter_test.dart';
import 'package:routex/routex.dart';

import 'util/test_util.dart';

void main() {
  test('Mount subRouter test', () async {
    var router = getRouter();

    router
      .route("/main")
      .handler((context) => context.response().end("ok"));

    var subRouter = Router.router();

    subRouter
        .route("/main") //subRouter also routes to /main
        .handler((context) => context.response().end("v1 ok"));

    router.mountSubRouter("/v1", subRouter);

    expect(await testRequest("/main"), "ok");
    expect(await testRequest("/v1/main"), "v1 ok");
  });

  test('Mount testFailCalled1', () async {
    var router = getRouter();

    var subRouter = Router.router();

    router.mountSubRouter("/subpath", subRouter);

    subRouter
      .route("/foo/*")
      .handler((rc) => rc.fail(557));

    expect(await testRequest("/subpath/foo/bar"), 557);
  });

  //
}
