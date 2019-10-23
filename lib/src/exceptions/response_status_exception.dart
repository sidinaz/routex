import 'package:routex/src/util/objects.dart';

class ResponseStatusException implements Exception {
  final int statusCode;
  final Object failure;

  ResponseStatusException(this.statusCode, [this.failure]);

  @override
  String toString() {
    String message = "ResponseStatusException: $statusCode";
    if (failure != null) {
      if (Objects.cast<Error>(failure, (error) => print(error.stackTrace)) !=
        null) {
        message += failure.toString();
      } else if (Objects.cast<Exception>(failure) != null) {
        message += failure.toString();
      } else {
        message += failure.toString();
      }
    }
    return message;
  }
}