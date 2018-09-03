// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  final String basePath = "/users";
  Future<User> getUserById(String id, String test) async {
    var req = base.get
        .metadata({
          "token": "test",
          "bool": true,
          "int": 1,
          "double": 2.2,
        })
        .path(basePath)
        .path("/:id")
        .pathParams("id", id)
        .query("test", test);
    return req.one(convert: serializers.oneFrom);
  }

  Future<User> createUser(User user) async {
    var req = base.post
        .metadata({
          "base": "test",
        })
        .path(basePath)
        .path("/")
        .json(serializers.to(user));
    return req.one(convert: serializers.oneFrom);
  }

  Future<User> updateUser(String id, User user) async {
    var req = base.put
        .metadata({
          "base": "test",
        })
        .path(basePath)
        .path("/:id")
        .pathParams("id", id)
        .json(serializers.to(user));
    return req.one(convert: serializers.oneFrom);
  }

  Future<void> deleteUser(String id) async {
    var req = base.delete
        .metadata({
          "base": "test",
        })
        .path(basePath)
        .path("/:id")
        .pathParams("id", id);
    await req.go();
  }

  Future<List<User>> all({String name, String email}) async {
    var req = base.get
        .metadata({
          "base": "test",
        })
        .path(basePath)
        .path("/");
    return req.list(convert: serializers.oneFrom);
  }

  Future<void> login(Login login) async {
    var req = base.post
        .metadata({
          "base": "test",
        })
        .path(basePath)
        .path("/login")
        .urlEncodedForm(serializers.to(login));
    await req.go();
  }

  Future<void> loginMultipart(Login login) async {
    var req = base.post
        .metadata({
          "base": "test",
        })
        .path(basePath)
        .path("/login")
        .multipart((serializers.to(login) as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value.toString())));
    await req.go();
  }
}
