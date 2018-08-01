import 'package:build/build.dart';
import 'generator/generator.dart';

Builder jaguarHttpBuilder(BuilderOptions options) =>
    jaguarHttpPartBuilder(header: options.config['header'] as String);
