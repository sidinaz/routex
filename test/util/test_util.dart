import 'package:flutter_test/flutter_test.dart';
import 'package:routex/routex.dart';

Router _router;

//assign new router on each getRouter call and then use _router
Router getRouter() => _router = Router.router();

Future<dynamic> testRequest([String path,RoutingRequest req, bool returnStatusCode = false]) async {
  RoutingRequest request;
  if (req == null){
    if (path != null) {
      request = BaseRequest<String>(path);
    }else{
      throw "Missing path or request";
    }
  }else{
    request = req;
  }

  try {
    var result = await _router.handle(request).asFuture();
    return returnStatusCode ? 200 : result;
  } catch (error) {
    return (error is ResponseStatusException) ? error.statusCode : throw error;
  }
}
