library jaguar_http.example;

import 'dart:io';
import 'dart:async';
import 'package:http/io_client.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:jaguar/jaguar.dart' as jaguar;

part 'path_param_at_up.jretro.dart';

/// Example showing how to define an [ApiClient]
@GenApiClient(path: "/api/:test", metadata: {"base": "test"})
class SampleApi extends ApiClient with _$SampleApiClient {
  final resty.Route base;

  final JsonRepo jsonConverter;

  SampleApi({this.base, this.jsonConverter});

  @GetReq()
  Future<String> test(@PathParam("test") String test);
}

final repo = JsonRepo();

void server() async {
  final server = jaguar.Jaguar(port: 10000);
  server.getJson("/api/:test", (_) => _.pathParams["test"]);
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}

void client() async {
  globalClient = IOClient();
  var api =
      SampleApi(base: route("http://localhost:10000"), jsonConverter: repo);

  print(await api.test("hello"));
}

main() async {
  await server();
  await client();
  exit(0);
}
