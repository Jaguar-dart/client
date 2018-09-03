import '../parsed_info/parsed_info.dart';
import 'package:analyzer/dart/element/element.dart'
    show MethodElement, ParameterElement;

class Writer {
  final WriteInfo i;
  final sb = StringBuffer();
  Writer(this.i);

  void generate() {
    sb.writeln('abstract class _\$${i.name}Client implements ApiClient {');
    sb.writeln('final String basePath = "${i.basePath}";');
    for (Req req in i.requests) _writeRequest(req);

    sb.writeln('}');
  }

  void _writeMetaData(Map<dynamic, dynamic> metaData) {
    sb.write('.setMetaData({');
    metaData.forEach((key, value) {
      sb.write('"${key.toStringValue()}":');

      if (value.toStringValue() != null) {
        sb.write('"${value.toStringValue()}",');
      } else if (value.toBoolValue() != null) {
        sb.write('${value.toBoolValue()},');
      } else if (value.toIntValue() != null) {
        sb.write('${value.toIntValue()},');
      } else if (value.toDoubleValue() != null) {
        sb.write('${value.toDoubleValue()},');
      } else if (value is List) {
        throw UnsupportedError("$key: List is not supported as meta data");
      } else if (value is Map) {
        throw UnsupportedError("$key: Map is not supported as meta data");
      } else {
        throw UnsupportedError("$key: Type is not supported as meta data");
      }
    });
    sb.write('})');
  }

  void _writeRequest(Req r) {
    sb.write(_writeFunctionSignature(r.me));

    sb.writeln(' async {');

    sb.write('var req = base.${r.method}');

    if (r.metaData != null) {
      _writeMetaData(r.metaData);
    } else if (i.baseMetaData != null) {
      _writeMetaData(i.baseMetaData);
    }

    if (i.basePath != null) sb.write('.path(basePath)');
    if (r.path != null) sb.write('.path("${r.path}")');

    for (String path in r.pathParams) sb.write('.pathParams("$path", $path)');
    for (String path in i.basePathParams)
      sb.write('.pathParams("$path", $path)');

    r.query.forEach((String key, String valueField) {
      sb.write('.query("$key", $valueField)');
    });

    r.headers.forEach((String key, String valueField) {
      sb.write('.header("$key", $valueField)');
    });

    r.queryMap.forEach((String name) {
      sb.write('.queries($name)');
    });

    r.headerMap.forEach((String name) {
      sb.write('.headers($name)');
    });

    for (Body body in r.body) {
      if (body is JsonBody) {
        sb.write('.json(serializers.to(${body.name}))');
      }

      if (body is FormBody) {
        sb.write('.urlEncodedForm(serializers.to(${body.name}))');
      }

      if (body is FormFieldBody) {
        sb.write('.urlEncodedFormField(${body.key}, ${body.name})');
      }

      if (body is MultipartForm) {
        sb.write(
            '.multipart((serializers.to(${body.name}) as Map<String, dynamic>).map((key, value) => MapEntry(key, value.toString())))');
      }

      if (body is MultipartFormField) {
        sb.write('.multipartField(${body.key}, ${body.name})');
      }
    }

    sb.writeln(';');

    if (r.result.returnsVoid) {
      sb.writeln('await req.go();');
    } else if (r.result.model != null) {
      if (r.result.isResultList) {
        sb.writeln('return req.list(convert: serializers.oneFrom);');
      } else {
        sb.writeln('return req.one(convert: serializers.oneFrom);');
      }
    } else {
      sb.writeln('return serializers.from(await req.go().body);');
    }

    sb.writeln('}');
  }

  String toString() => sb.toString();
}

String _writeFunctionSignature(MethodElement me) {
  var sb = StringBuffer();

  sb.write(me.returnType.toString());
  sb.write(' ');
  sb.write(me.displayName);
  // TODO Type parameters
  sb.write('(');

  bool isFirstParam = true;
  bool isOptional = false;
  bool isOptionalNamed = false;

  for (ParameterElement p in me.parameters) {
    if (!isFirstParam) sb.write(', ');
    isFirstParam = false;
    if (p.isOptional) {
      if (!isOptional) {
        isOptionalNamed = p.isNamed;
        if (isOptionalNamed) {
          sb.write('{');
        } else {
          sb.write('[');
        }
      }
      isOptional = true;
    }
    sb.write(_writeParameter(p));
  }
  if (isOptional) {
    if (isOptionalNamed) {
      sb.write('}');
    } else {
      sb.write(']');
    }
  }

  sb.write(')');
  return sb.toString();
}

String _writeParameter(ParameterElement parameter) {
  var sb = StringBuffer();

  sb.write(parameter.type.toString());
  sb.write(' ');
  sb.write(parameter.displayName);

  return sb.toString();
}
