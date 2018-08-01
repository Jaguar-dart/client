import 'package:build_runner/build_runner.dart' as _i1;
import 'package:jaguar_serializer_cli/builder.dart' as _i2;
import 'package:jaguar_http_gen/builder.dart' as _i3;
import 'dart:isolate' as _i4;

final _builders = <_i1.BuilderApplication>[
  _i1.apply('jaguar_serializer_cli|jaguar_serializer_cli',
      [_i2.jaguarSerializer], _i1.toRoot(),
      hideOutput: false),
  _i1.apply('declarative_client_gen|declarative_client_gen',
      [_i3.jaguarHttpBuilder], _i1.toRoot(),
      hideOutput: false)
];
main(List<String> args, [_i4.SendPort sendPort]) async {
  var result = await _i1.run(args, _builders);
  sendPort?.send(result);
}
