class Config{
  static final Config shared = Config._();

  final AppMode _appMode = AppMode.DEVELOPMENT;
  final String initialRoute = "/app/main/";

  Config._();

  bool get isDevelopmentMode => _appMode == AppMode.DEVELOPMENT;

}

enum AppMode{
  DEVELOPMENT, PRODUCTION
}