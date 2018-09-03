// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  final String basePath = "/users/:test";
  Future<User> getUserById(String test, String id, String param) async {
    var req = base.get
        .setMetaData({
          "token": "test",
          "bool": true,
          "int": 1,
          "double": 2.2,
        })
        .path(basePath)
        .path("/:id")
        .pathParams("id", id)
        .pathParams("test", test)
        .query("qparam", param);
    return req.one(convert: serializers.oneFrom);
  }

  Future<User> createUser(String test, User user) async {
    var req = base.post
        .setMetaData({
          "base": "test",
        })
        .path(basePath)
        .path("/")
        .pathParams("test", test)
        .json(serializers.to(user));
    return req.one(convert: serializers.oneFrom);
  }

  Future<User> updateUser(String test, String id, User user) async {
    var req = base.put
        .setMetaData({
          "base": "test",
        })
        .path(basePath)
        .path("/:id")
        .pathParams("id", id)
        .pathParams("test", test)
        .json(serializers.to(user));
    return req.one(convert: serializers.oneFrom);
  }

  Future<void> deleteUser(String test, String id) async {
    var req = base.delete
        .setMetaData({
          "base": "test",
        })
        .path(basePath)
        .path("/:id")
        .pathParams("id", id)
        .pathParams("test", test);
    await req.go();
  }

  Future<List<User>> all(String test, {String name, String email}) async {
    var req = base.get
        .setMetaData({
          "base": "test",
        })
        .path(basePath)
        .path("/")
        .pathParams("test", test);
    return req.list(convert: serializers.oneFrom);
  }

  Future<void> login(String test, Login login) async {
    var req = base.post
        .setMetaData({
          "base": "test",
        })
        .path(basePath)
        .path("/login")
        .pathParams("test", test)
        .urlEncodedForm(serializers.to(login));
    await req.go();
  }

  Future<void> loginMultipart(String test, Login login) async {
    var req = base.post
        .setMetaData({
          "base": "test",
        })
        .path(basePath)
        .path("/login")
        .pathParams("test", test)
        .multipart((serializers.to(login) as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value.toString())));
    await req.go();
  }
}
