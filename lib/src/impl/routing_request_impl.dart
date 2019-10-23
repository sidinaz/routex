import 'package:flutter/material.dart';
import 'package:routex/src/content_type.dart';
import 'package:routex/src/impl/routing_response_impl.dart';
import 'package:routex/src/routing_request.dart';
import 'package:routex/src/routing_response.dart';

class BaseRequest<T> extends RoutingRequestImpl<T> {
  BaseRequest(String path, {Map<String, dynamic> params})
    : super(path, params: params);
}

class RoutingRequestImpl<T> implements RoutingRequest<T> {
  RoutingResponse<T> _response = BaseResponse<T>();
  String _path;
  final ContentType _contentType;
  final Map<String, dynamic> _params;

  RoutingRequestImpl(this._path,
    {BuildContext contex, Map<String, dynamic> params})
    : this._params = params == null ? Map() : params,
      this._contentType = _contentFromType<T>();

  void setPath(String path) => _path = path;


  @override
  String path() => _path;

  @override
  BaseResponse<T> response() => _response;

  @override
  Map<String, dynamic> params() => _params;

  @override
  ContentType content() => _contentType;

  static Type typeOf<T>() => T;

  static ContentType _contentFromType<T>() {
    Type type = typeOf<T>();
    if (type.toString() == "String") {
      return ContentType.STRING;
    }
    if (type.toString() == "(BuildContext) => Widget") {
      return ContentType.WIDGET_BUILDER;
    }
    if (type.toString() == "dynamic") {
      return ContentType.DYNAMIC;
    }
    return ContentType.OBJECT;
  }
}
