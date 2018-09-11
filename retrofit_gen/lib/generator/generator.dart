import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:source_gen/source_gen.dart';
import 'package:logging/logging.dart';

import '../parsed_info/parsed_info.dart';
import '../parser/parser.dart';
import '../writer/writer.dart';

final _log = new Logger("JaguarHttpGenerator");

final _onlyClassException =
    Exception("GenSerializer annotation can only be defined on a class.");

/// source_gen hook to generate serializer
class JaguarHttpGenerator extends GeneratorForAnnotation<GenApiClient> {
  const JaguarHttpGenerator();

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) throw _onlyClassException;

    try {
      WriteInfo wi = parse(element, annotation);
      // TODO
      return (Writer(wi)..generate()).toString();
    } catch (e, s) {
      _log.severe(e);
      _log.severe(s);
      return "/* $e \n\n $s \n\n */";
    }
  }
}

Builder jaguarRetrofitPartBuilder({String header}) =>
    PartBuilder([JaguarHttpGenerator()], '.jretro.dart', header: header);
