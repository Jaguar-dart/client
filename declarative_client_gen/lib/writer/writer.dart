import '../parsed_info/parsed_info.dart';
import 'package:analyzer/dart/element/element.dart'
    show MethodElement, ParameterElement;

class Writer {
  final WriteInfo i;
  final sb = StringBuffer();
  Writer(this.i);

  void generate() {
    sb.writeln('abstract class _\$${i.name}Client implements ApiClient {');

    for (Req req in i.requests) _writeRequest(req);

    sb.writeln('}');
  }

  void _writeRequest(Req r) {
    sb.write(_writeFunctionSignature(r.me));

    sb.writeln(' async {');

    sb.write('var req = base.${r.method}');

    if (r.path != null) sb.write('.path("${r.path}")');

    for(String path in r.pathParams) sb.write('.pathParams("$path", $path)');

    r.query.forEach((String key, String valueField) {
      sb.write('.query("$key", $valueField)');
    });

    r.query.forEach((String key, String valueField) {
      sb.write('.header("$key", $valueField)');
    });

    sb.writeln(';');

    // TODO parse response body if needed
    sb.writeln('await req.go();');

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
