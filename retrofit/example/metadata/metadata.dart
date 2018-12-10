library jaguar_http.example;

import 'dart:io';
import 'dart:async';
import 'package:http/io_client.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:jaguar/jaguar.dart' as jaguar;

part 'metadata.jretro.dart';

/// Example showing how to define an [ApiClient]
@GenApiClient(path: "/api/meta", metadata: {"base": "test"})
class SampleApi extends ApiClient with _$SampleApiClient {
  final resty.Route base;

  final JsonRepo jsonConverter;

  SampleApi({this.base, this.jsonConverter});

  @GetReq(path: "/:id", metadata: {
    "token": "test",
    "bool": true,
    "int": 1,
    "double": 2.2,
    "list": ["test", "ok"],
    "auth": [
      {"test": "ok"}
    ]
  })
  Future<void> meta();
}

final repo = JsonRepo();

void server() async {
  final server = jaguar.Jaguar(port: 10000);
  server.get("/users/meta", (_) => "hello");
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}

void client() async {
  globalClient = IOClient();
  var api = SampleApi(
      base: route("http://localhost:10000")
        ..before((route) {
          print("Metadata: ${route.metadataMap}");
        }),
      jsonConverter: repo);

  await api.meta();
}

main() async {
  await server();
  await client();
  exit(0);
}
