// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  final String basePath = "user";
  Future<User> getUserById(String id) async {
    var req = base.get.path(basePath).path(":id").pathParams("id", id);
    return req.go(throwOnErr: true).then(decodeOne);
  }

  Future<List<User>> all() async {
    var req = base.get.path(basePath);
    return req.go(throwOnErr: true).then(decodeList);
  }

  Future<User> createUser(User user) async {
    var req = base.post
        .path(basePath)
        .json(converters[ApiClient.contentTypeJson].to(user));
    return req.go(throwOnErr: true).then(decodeOne);
  }

  Future<User> updateUser(String id, User user) async {
    var req = base.put
        .path(basePath)
        .path(":id")
        .json(converters[ApiClient.contentTypeJson].to(user));
    return req.go(throwOnErr: true).then(decodeOne);
  }

  Future<void> deleteUser(String id) async {
    var req = base.delete.path(basePath).path(":id");
    await req.go(throwOnErr: true);
  }

  Future<void> login(Login login) async {
    var req = base.post
        .path(basePath)
        .path("/login")
        .urlEncodedForm(converters[ApiClient.contentTypeJson].to(login));
    await req.go(throwOnErr: true);
  }

  Future<void> avatar(List<int> data) async {
    var req = base.patch.path(basePath).path("/avatar").bytes(data);
    await req.go(throwOnErr: true);
  }

  Future<User> serialize(User data) async {
    final dataData = converters['application/json'].encode(data);
    var req = base.post.path(basePath);
    if (dataData is String) {
      req = req.header('Content-Type', 'application/json').body(dataData);
    } else {
      req = req.header('Content-Type', 'application/json').bytes(dataData);
    }
    return req.go(throwOnErr: true).then(decodeOne);
  }
}
