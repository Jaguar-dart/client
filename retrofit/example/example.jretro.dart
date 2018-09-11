// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  final String basePath = "user";
  Future<User> getUserById(String id) async {
    var req = base.get.path(basePath).path(":id").pathParams("id", id);
    return req.one(convert: serializers.oneFrom);
  }

  Future<List<User>> all() async {
    var req = base.get.path(basePath).path("");
    return req.list(convert: serializers.oneFrom);
  }

  Future<User> createUser(User user) async {
    var req = base.post.path(basePath).path("").json(serializers.to(user));
    return req.one(convert: serializers.oneFrom);
  }

  Future<User> updateUser(String id, User user) async {
    var req = base.put.path(basePath).path(":id").json(serializers.to(user));
    return req.one(convert: serializers.oneFrom);
  }

  Future<void> deleteUser(String id) async {
    var req = base.delete.path(basePath).path(":id");
    await req.go();
  }

  Future<void> login(Login login) async {
    var req = base.post
        .path(basePath)
        .path("/login")
        .urlEncodedForm(serializers.to(login));
    await req.go();
  }
}
