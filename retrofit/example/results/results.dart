library jaguar_http.example;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:jaguar/jaguar.dart' as jaguar;

part 'results.jretro.dart';

/// Example showing how to define an [ApiClient]
@GenApiClient(path: "results")
class UserApi extends _$UserApiClient implements ApiClient {
  final resty.Route base;

  final SerializerRepo serializers;

  UserApi({this.base, this.serializers});

  @GetReq(path: "/map")
  Future<Map<String, int>> map(String test);
}

final repo = JsonRepo();

void server() async {
  final server = jaguar.Jaguar(port: 10000);
  server.get("/results/map", (_) => {"hello": 5});
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}

void client() async {
  globalClient = IOClient();
  var api = UserApi(
      base: route("http://localhost:10000")
        ..before((route) {
          print("Metadata: ${route.metadataMap}");
        }),
      serializers: repo);

  try {
    print(await api.map("hello"));
  } on resty.Response catch (e) {
    print(e.body);
  }
}

main() async {
  await server();
  await client();
  exit(0);
}
