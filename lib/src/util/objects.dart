class Objects {
  static T requireNonNull<T>(T obj, [String message]) {
    return obj != null
        ? obj
        : throw FormatException(message != null ? message : "Object is null");
  }

  static cast<T>(Object obj, [Function(T) run]) {
    try {
      if (obj == null) {
        return null;
      }
      var value = obj as T;
      if (run != null) {
        run(value);
      }
      return value;
    } catch (_) {
      return null;
    }
  }
}

//T Function(T)
