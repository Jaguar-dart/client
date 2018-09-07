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

  void _writeMetadata(Map<String, String> metadata) {
    sb.write('.metadata({');
    metadata.forEach((key, value) => sb.write('"$key": $value,'));
    sb.write('})');
  }

  void _writeRequest(Req r) {
    sb.write(_writeFunctionSignature(r.me));

    sb.writeln(' async {');

    sb.write('var req = base.${r.method}');

    if (i.baseMetadata.isNotEmpty) {
      _writeMetadata(i.baseMetadata);
    }
    if (r.metadata.isNotEmpty) {
      _writeMetadata(r.metadata);
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
        sb.write('.multipart({"${body.key}": ${body.name}})');
      }
    }

    sb.writeln(';');

    if (r.result.returnsVoid) {
      sb.writeln('await req.go();');
    } else if (r.result.model != null) {
      if (r.result.isResultList) {
        sb.writeln('return req.list(convert: serializers.oneFrom);');
      } else if (r.result.isStringResponse) {
        sb.writeln('return req.go();');
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
