import 'package:routex/src/content_type.dart';

abstract class Route {
  Route handler(Object handler);

  Route failureHandler(Object handler);

  Route content(ContentType content);

  Set<ContentType> contents();

  String getPath();

  Route setRegexGroupsNames(List<String> groups);
}
