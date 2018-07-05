import 'dart:async';
import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:jaguar_http/jaguar_http.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/utils.dart';
import 'package:code_builder/code_builder.dart';
import 'package:logging/logging.dart';
import "utils.dart";

final _log = new Logger("JaguarHttpGenerator");

/// source_gen hook to generate serializer
class JaguarHttpGenerator extends GeneratorForAnnotation<JaguarHttp> {
  const JaguarHttpGenerator();

  final _onlyClassMsg =
      "GenSerializer annotation can only be defined on a class.";

  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) throw new Exception(_onlyClassMsg);

    try {
      // TODO
      return "// TODO not implemented!";
    } on Exception catch (e, s) {
      _log.severe(e);
      _log.severe(s);
      return "// $e \n\n";
    }
  }
}

Builder jaguarHttpPartBuilder({String header}) =>
    new PartBuilder([JaguarHttpGenerator()],
        header: header, generatedExtension: '.jhttp.dart');

class GetInfo {

}

class Writer {
  String name;

  String generate() {
    var sb = StringBuffer();

    sb.writeln('class _\$${name}Impl extends ApiClient with $name {');
    sb.writeln('}');
    return sb.toString();
  }

  void writeGet(StringBuffer sb, GetInfo info) {
    sb.writeln("Future ");
    // TODO
  }
}