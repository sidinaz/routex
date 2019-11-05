import 'package:flutter_test/flutter_test.dart';
import 'package:routex/routex.dart';

import 'util/test_util.dart';

void main() {

  test('Regex testRegex1', () async {
    var router = getRouter();

    router
      .routeWithRegex(r"\/([^\/]+)\/([^\/]+)")
      .handler((context) => context.response().end(context.getParam("param0") + context.getParam("param1")));

    expect(await testRequest("/dog/cat"), "dogcat");
  });

  test('Regex testRegex2', () async {
    var router = getRouter();

    router
      .routeWithRegex(r"\/([^\/]+)\/([^\/]+)/blah")
      .handler((context) => context.response().end(context.getParam("param0") + context.getParam("param1")));

    expect(await testRequest("/dog/cat/blah"), "dogcat");
  });

  test('Regex testRegex3', () async {
    var router = getRouter();

    router
      .routeWithRegex(r".*foo.txt")
      .handler((context) => context.response().end("ok"));

    expect(await testRequest("/dog/cat/foo.txt"), "ok");
    expect(await testRequest("/dog/cat/foo.bar"), 404);
  });

  test('Regex testRegex4', () async {
    var router = getRouter();

    router
      .routeWithRegex(r"^\/images\/(?<name>[a-zA-Z0-9]+).(jpg|png|gif|bmp)$")
      .handler((context) => context.response().end(context.getParam("name")));

    expect(await testRequest("/images/autumn.jpg"), "autumn");
  });

  test('Regex testRegex5', () async {
    var router = getRouter();

    router
      .routeWithRegex(r"^(\/v1)?\/app/*")
      .handler((context) => context.response().end("ok"));

    expect(await testRequest("/app/main"), "ok");
    expect(await testRequest("/v1/app/main"), "ok");
  });

  test('Regex testRegexWithNamedParams', () async {
    var router = getRouter();

    router
      .routeWithRegex(r"\/(?<name>[^\/]+)\/(?<surname>[^\/]+)")
      .handler((context) => context.response().end(context.getParam("name") + context.getParam("surname")));

    expect(await testRequest("/joe/doe"), "joedoe");
  });

  test('Regex testRegexWithNamedParamsKeepsIndexedParams', () async {
    var router = getRouter();

    router
      .routeWithRegex(r"\/(?<name>[^\/]+)\/(?<surname>[^\/]+)")
      .handler((context) => context.response().end(context.getParam("param0") + context.getParam("param1")));

    expect(await testRequest("/joe/doe"), "joedoe");
  });

  test('Regex testSetRegexGroupsNamesMethod', () async {

    List<String> groupNames = ["hello"];

    var router = getRouter();

    Route route = router
      .routeWithRegex(r"\/(?<p0>[a-z]{2})");

    route.setRegexGroupsNames(groupNames);

    route.handler((context) => context.response().end(context.getParam("hello")));

    expect(await testRequest("/hi"), "hi");
  });

  test('Regex testRegexGroupsNamesWithMethodOverride', () async {

    List<String> groupNames = ["FirstParam", "SecondParam"];

    var router = getRouter();

    Route route = router
      .routeWithRegex(r"\/([a-z]{2})([a-z]{2})");

    route.setRegexGroupsNames(groupNames);

    route.handler((context) => context.response().end(context.getParam("FirstParam") + "-" + context.getParam("SecondParam")));

    expect(await testRequest("/aabb"), "aa-bb");
  });

  test('Regex testSetRegexGroupsNamesMethodWithUnorderedGroups', () async {

    List<String> groupNames = ["firstParam", "secondParam"];

    var router = getRouter();

    Route route = router
      .routeWithRegex(r"\/(?<p1>[a-z]{2})(?<p0>[a-z]{2})");

    route.setRegexGroupsNames(groupNames);

    route.handler((context) => context.response().end(context.getParam("firstParam") + "-" + context.getParam("secondParam")));

    expect(await testRequest("/bbaa"), "aa-bb");
  });

  test('Regex testSetRegexGroupsNamesMethodWithNestedRegex', () async {

    List<String> groupNames = ["firstParam", "secondParam"];

    var router = getRouter();

    Route route = router
      .routeWithRegex(r"\/(?<p1>[a-z]{2}(?<p0>[a-z]{2}))");

    route.setRegexGroupsNames(groupNames);

    route.handler((context) => context.response().end(context.getParam("firstParam") + "-" + context.getParam("secondParam")));

    expect(await testRequest("/bbaa"), "aa-bbaa");
  });

  test('Regex testRegexGroupsNames', () async {
    var router = getRouter();

    router
      .routeWithRegex(r"\/(?<firstParam>[a-z]{2})(?<secondParam>[a-z]{2})")
      .handler((context) => context.response().end(context.getParam("firstParam") + "-" + context.getParam("secondParam")));

    expect(await testRequest("/aabb"), "aa-bb");
  });

  test('Regex testRegexGroupsNamesWithNestedGroups', () async {
    var router = getRouter();

    router
      .routeWithRegex(r"\/(?<secondParam>[a-z]{2}(?<firstParam>[a-z]{2}))")
      .handler((context) => context.response().end(context.getParam("firstParam") + "-" + context.getParam("secondParam")));

    expect(await testRequest("/bbaa"), "aa-bbaa");
  });

}
