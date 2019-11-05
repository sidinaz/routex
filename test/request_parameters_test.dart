import 'package:flutter_test/flutter_test.dart';
import 'package:routex/routex.dart';

import 'util/test_util.dart';

void main() {

  test('Passing parameters', () async {
    var router = getRouter();

    var firstRequest = BaseRequest<String>("/first", params: { "firstParam" : "aa", "secondParam" : "bb" });

    router
      .route("/first")
      .handler((context) => context.response().end(context.getParam("firstParam") + "-" + context.getParam("secondParam")));

    router
      .route("/second/:a/:b")
      .handler((context) => context.response().end(context.getParam("a") + "-" + context.getParam("b")));

    router
      .routeWithRegex(r"\/third\/(?<p0>[a-z]{2})(?<p1>[a-z]{2})")
      .setRegexGroupsNames(["firstParam", "secondParam"])
      .handler((context) => context.response().end(context.getParam("firstParam") + "-" + context.getParam("secondParam")));

    router
      .routeWithRegex(r"\/fourth\/(?<p1>[a-z]{2})(?<p0>[a-z]{2})")
      .setRegexGroupsNames(["firstParam", "secondParam"])
      .handler((context) => context.response().end(context.getParam("firstParam") + "-" + context.getParam("secondParam")));

    router
      .routeWithRegex(r"\/([a-z]{2})([a-z]{2})")
      .setRegexGroupsNames(["firstParam", "secondParam"])
      .handler((context) => context.response().end(context.getParam("firstParam") + "-" + context.getParam("secondParam")));

    router
      .routeWithRegex(r"\/sixth\/(?<firstParam>[a-z]{2})(?<secondParam>[a-z]{2})")
      .handler((context) => context.response().end(context.getParam("firstParam") + "-" + context.getParam("secondParam")));

    List result = [
      await testRequest(null, firstRequest),
      await testRequest("/second/aa/bb"),
      await testRequest("/third/aabb"),
      await testRequest("/fourth/bbaa"),
      await testRequest("/fifth/aabb"),
      await testRequest("/sixth/aabb"),
    ];

    expect(result.every((response) => response == "aa-bb" ), isTrue);

  });
}