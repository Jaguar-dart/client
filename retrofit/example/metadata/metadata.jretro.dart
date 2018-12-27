// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$SampleApiClient implements ApiClient {
  final String basePath = "/api/meta";
  Future<void> meta() async {
    var req = base.get
        .metadata({
          "base": "test",
        })
        .metadata({
          "token": "test",
          "bool": true,
          "int": 1,
          "double": 2.2,
          "list": ["test", "ok"],
          "auth": [
            {
              "test": "ok",
            }
          ],
        })
        .path(basePath)
        .path("/:id");
    await req.go(throwOnErr: true);
  }
}
