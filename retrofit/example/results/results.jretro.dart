// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  final String basePath = "results";
  Future<Map<String, int>> map(String test) async {
    var req = base.get.path(basePath).path("/map");
    return req.one().then((v) => serializers.mapFrom<int>(v));
  }
}
