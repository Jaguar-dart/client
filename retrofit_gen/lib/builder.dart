import 'package:build/build.dart';
import 'generator/generator.dart';

Builder jaguarRetrofitBuilder(BuilderOptions options) =>
    jaguarRetrofitPartBuilder(header: options.config['header'] as String);
