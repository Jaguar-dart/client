// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$SampleApiClient implements ApiClient {
  final String basePath = "/api/:test";
  Future<String> test(String test) async {
    var req = base.get
        .metadata({
          "base": "test",
        })
        .path(basePath)
        .pathParams("test", test);
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
