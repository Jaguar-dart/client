// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  final String basePath = "user";
  Future<User> getUserById(String id) async {
    var req = base.get.path(basePath).path(":id").pathParams("id", id);
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<List<User>> all() async {
    var req = base.get.path(basePath);
    return req.go(throwOnErr: true).map(decodeList);
  }

  Future<User> createUser(User user) async {
    var req = base.post.path(basePath).json(jsonConverter.to(user));
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<User> updateUser(String id, User user) async {
    var req = base.put
        .path(basePath)
        .path(":id")
        .pathParams("id", id)
        .json(jsonConverter.to(user));
    return req.go(throwOnErr: true).map(decodeOne);
  }

  Future<void> deleteUser(String id) async {
    var req = base.delete.path(basePath).path(":id").pathParams("id", id);
    await req.go(throwOnErr: true);
  }

  Future<void> login(Login login) async {
    var req = base.post
        .path(basePath)
        .path("/login")
        .urlEncodedForm(jsonConverter.to(login));
    await req.go(throwOnErr: true);
  }

  Future<void> avatar(List<int> data) async {
    var req = base.patch.path(basePath).path("/avatar").body(data);
    await req.go(throwOnErr: true);
  }

  Future<User> serialize(User data) async {
    var req = base.post
        .path(basePath)
        .mimeType('application/json')
        .body(converters["application/json"].encode(data));
    return req.go(throwOnErr: true).map(decodeOne);
  }
}
