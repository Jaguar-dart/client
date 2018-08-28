import 'package:analyzer/dart/element/element.dart' show MethodElement;
import 'package:analyzer/dart/element/type.dart';
import 'package:jaguar_retrofit_gen/utils/utils.dart';

abstract class Body {}

class JsonBody implements Body {
  final String name;
  const JsonBody(this.name);
}

class UrlEncodedForm implements Body {}

class MultipartForm implements Body {
  final String name;
  const MultipartForm(this.name);
}

class Result {
  final MethodElement me;

  bool returnsVoid = false;

  bool returnsDynamic = false;

  bool isResultList = false;

  DartType model;

  // TODO result could be response

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
    } else if (isMap.isAssignableFromType(rt)) {
      returnsDynamic = true;
    } else {
      model = rt;
    }
  }
}

class Req {
  String get name => me.displayName;

  final String method;

  final String path;

  final Set<String> pathParams;

  final Map<String, String> query;

  final Map<String, String> headers;

  final Set<String> queryMap;

  final Set<String> headerMap;

  final Body body;

  final MethodElement me;

  final Result result;

  Req(this.method, this.me,
      {this.path,
      this.query,
      this.headers,
      this.body,
      this.pathParams,
      this.headerMap,
      this.queryMap})
      : result = Result(me);
}

class WriteInfo {
  final String name;

  final List<Req> requests;

  WriteInfo(this.name, this.requests);
}
