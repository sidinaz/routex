import '../model/user.dart';

class AppComponent {
  static final String key = "app_component";

  User _user = User("Flutter");

  AppComponent._();

  static Future<AppComponent> create() async => AppComponent._();

  setUser(User value) => _user = value;

  Future<User> loadUser() => Future.delayed(Duration(milliseconds: 1), () => _user);
}
