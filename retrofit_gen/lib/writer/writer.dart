import '../parsed_info/parsed_info.dart';
import 'package:analyzer/dart/element/element.dart'
    show MethodElement, ParameterElement;
import 'package:analyzer/dart/element/type.dart';

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

  void _writeMetadata(Map<String, String> metadata) {
    sb.write('.metadata({');
    metadata.forEach((key, value) => sb.write('"$key": $value,'));
    sb.write('})');
  }

  void _writeRequest(Req r) {
    sb.write(_writeFunctionSignature(r.me));

    sb.writeln(' async {');

    for (Body body in r.body) {
      if (body is SerializedBody) {
        sb.writeln('final ${body.name}Data = converters[\'${body.contentType}\'].encode(${body.name});');
      }
    }
    sb.write('var req = base.${r.method}');

    if (i.baseMetadata.isNotEmpty) {
      _writeMetadata(i.baseMetadata);
    }
    if (r.metadata.isNotEmpty) {
      _writeMetadata(r.metadata);
    }

    if (i.basePath != null) sb.write('.path(basePath)');
    if (r.path != null && r.path.isNotEmpty) sb.write('.path("${r.path}")');

    r.pathParams.forEach((String key, String valueField) {
      sb.write('.pathParams("$key", $valueField)');
    });

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

    r.headerHooks.forEach((String key, String valueField) {
      sb.write('.hookHeader("$key", $valueField)');
    });

    for (Body body in r.body) {
      if (body is RawBody) {
        sb.write('.bytes(${body.name})');
      }

      if (body is StringBody) {
        sb.write('.body(${body.name}?.toString())');
      }

      if (body is JsonBody) {
        sb.write('.json(converters[ApiClient.contentTypeJson].to(${body.name}))');
      }

      if (body is FormBody) {
        sb.write('.urlEncodedForm(converters[ApiClient.contentTypeJson].to(${body.name}))');
      }

      if (body is FormFieldBody) {
        sb.write('.urlEncodedFormField(${body.key}, ${body.name})');
      }
      if (body is MultipartForm) {
        if (body.serialize) {
          sb.write(
              '.multipart((converters[ApiClient.contentTypeJson].to(${body.name}) as Map<String, dynamic>).map((key, value) => MapEntry(key, value.toString())))');
        } else {
          sb.write('.multipart(${body.name})');
        }
      }

      if (body is MultipartFormField) {
        sb.write('.multipart({"${body.key}": ${body.name}})');
      }
    }

    sb.writeln(';');

    for (Body body in r.body) {
      if (body is SerializedBody) {
        sb.writeln('if(${body.name}Data is String) {');
        sb.write('req = req');
        sb.write('.header(\'Content-Type\', \'${body.contentType}\')');
        sb.writeln('.body(${body.name}Data);');
        sb.writeln('} else {');
        sb.write('req = req');
        sb.write('.header(\'Content-Type\', \'${body.contentType}\')');
        sb.writeln('.bytes(${body.name}Data);');
        sb.writeln('}');
      }
    }


    if (r.result.returnsVoid) {
      sb.writeln('await req.go(throwOnErr: true);');
    } else if (r.result.model != null) {
      if (r.result.isResultList) {
        sb.writeln('return req.go(throwOnErr: true).then(decodeList);');
      } else if (r.result.isStringResponse) {
        sb.writeln('return req.go(throwOnErr: true);');
      } else if (r.result.isResultBuiltin) {
        sb.writeln('return req.go(throwOnErr: true).then(decodeOne);');
      } else {
        sb.writeln('return req.go(throwOnErr: true).then(decodeOne);');
      }
    } else if (r.result.mapValueType != null) {
      // TODO
      sb.writeln(
          'return req.one().then((v) => jsonConverter.mapFrom<${r.result.mapValueType}>(v));');
    } else {
      sb.writeln('return await req.go(throwOnErr: true);');
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

  if (parameter.type is! FunctionType) {
    sb.write(parameter.type.toString());
  } else {
    sb.write("Function");
  }
  sb.write(' ');
  sb.write(parameter.displayName);

  return sb.toString();
}
