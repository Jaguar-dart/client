library jaguar_http.example;

import 'dart:io';
import 'dart:async';
import 'package:http/io_client.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:jaguar/jaguar.dart' as jaguar;

part 'results.jretro.dart';

/// Example showing how to define an [ApiClient]
@GenApiClient(path: "results")
class UserApi extends ApiClient with _$UserApiClient {
  final resty.Route base;

  UserApi(this.base);

  @GetReq(path: "/map")
  Future<Map<String, int>> map();

  @GetReq(path: "/error")
  Future<String> errorResp();
}

final repo = JsonRepo();

void server() async {
  final server = jaguar.Jaguar(port: 10000);
  server.getJson("/results/map", (_) => {"hello": 5});
  server.get("/results/error", (_) => 'What?', statusCode: 404);
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}

void client() async {
  globalClient = IOClient();
  var api = UserApi(route("http://localhost:10000"))..jsonConverter = repo;

  try {
    print(await api.map());
  } on resty.Response catch (e) {
    print(e.body);
  }

  try {
    print(await api.errorResp());
  } on resty.Response catch (e) {
    print(e.body);
  }
}

main() async {
  await server();
  await client();
  exit(0);
}
