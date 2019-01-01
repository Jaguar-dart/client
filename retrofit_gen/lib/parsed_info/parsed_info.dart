import 'package:analyzer/dart/element/element.dart' show MethodElement;
import 'package:analyzer/dart/element/type.dart';
import 'package:jaguar_retrofit_gen/utils/utils.dart';

abstract class Body {}

class RawBody implements Body {
  final String name;
  RawBody(this.name);
}

class JsonBody implements Body {
  final String name;
  JsonBody(this.name);
}

class SerializedBody implements Body {
  final String name;
  final String contentType;
  SerializedBody(this.name, this.contentType);
}

class MultipartForm implements Body {
  final bool serialize;
  final String name;
  MultipartForm(this.name, {this.serialize: true});
}

class MultipartFormField implements Body {
  final String key;
  final String name;
  MultipartFormField(this.key, this.name);
}

class FormBody implements Body {
  final String name;
  FormBody(this.name);
}

class FormFieldBody implements Body {
  final String key;
  final String name;
  FormFieldBody(this.key, this.name);
}

class Result {
  final MethodElement me;

  bool returnsVoid = false;

  bool returnsDynamic = false;

  bool isResultList = false;

  bool isResultBuiltin = false;

  String mapValueType;

  DartType model;

  bool get isStringResponse => isResponse.isAssignableFromType(model);

  Result(this.me) {
    DartType rt = me.returnType;

    if (rt.isDartAsyncFuture || rt.isDartAsyncFutureOr) {
      InterfaceType rtIt = rt;
      rt = rtIt.typeArguments.first;
    }

    if (rt.isVoid) {
      returnsVoid = true;
      return;
    }

    if (rt.isDynamic) {
      returnsDynamic = true;
      return;
    }

    if (isMap.isExactlyType(rt)) {
      InterfaceType rtIt = rt;
      DartType key = rtIt.typeArguments.first;
      DartType value = rtIt.typeArguments[1];
      if (!isString.isExactlyType(key)) {
        throw Exception("Maps should have String keys!");
      }
      if (isMap.isExactlyType(value) || isList.isExactlyType(value)) {
        throw Exception("Collections inside Map are not supported!");
      }
      mapValueType = value.displayName;
      return;
    }

    if (isList.isExactlyType(rt)) {
      InterfaceType rtIt = rt;
      DartType mod = rtIt.typeArguments.first;
      if (mod.isDynamic ||
          isMap.isAssignableFromType(mod) ||
          isList.isAssignableFromType(mod)) {
        returnsDynamic = true;
      } else {
        model = mod;
        isResultList = true;
      }
      return;
    }

    if (isBuiltin(rt)) isResultBuiltin = true;
    model = rt;
  }
}

class Req {
  String get name => me.displayName;

  final String method;

  final String path;

  final Map<String, String> metadata;

  final Map<String, String> pathParams;

  final Map<String, String> query;

  final Map<String, String> headers;

  final Set<String> queryMap;

  final Set<String> headerMap;

  final Map<String, String> headerHooks;

  final List<Body> body;

  final MethodElement me;

  final Result result;

  Req(this.method, this.me,
      {this.path,
      this.metadata,
      this.query,
      this.headers,
      this.body,
      this.pathParams,
      this.headerMap,
      this.queryMap,
      this.headerHooks})
      : result = Result(me);
}

class WriteInfo {
  final String name;
  final String basePath;
  final Map<String, String> baseMetadata;

  final List<Req> requests;

  WriteInfo(this.name, this.basePath, this.baseMetadata, this.requests);
}
