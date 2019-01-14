// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  final String basePath = "results";
  Future<Map<String, int>> map() async {
    var req = base.get.path(basePath).path("/map");
    return req
        .go()
        .map((r) => jsonConverter.decode(r.body).cast<String, int>());
  }

  Future<String> errorResp() async {
    var req = base.get.path(basePath).path("/error");
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
