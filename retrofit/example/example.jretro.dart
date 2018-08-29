// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  Future<User> getUserById(String id, String test) async {
    var req =
        base.get.path("/users/:id").pathParams("id", id).query("test", test);
    return req.one(convert: serializers.oneFrom);
  }

  Future<User> createUser(User user) async {
    var req = base.post.path("/users").json(serializers.to(user));
    return req.one(convert: serializers.oneFrom);
  }

  Future<User> updateUser(String id, User user) async {
    var req = base.put
        .path("/users/:id")
        .pathParams("id", id)
        .json(serializers.to(user));
    return req.one(convert: serializers.oneFrom);
  }

  Future<void> deleteUser(String id) async {
    var req = base.delete.path("/users/:id").pathParams("id", id);
    await req.go();
  }

  Future<List<User>> all({String name, String email}) async {
    var req = base.get.path("/users");
    return req.list(convert: serializers.oneFrom);
  }

  Future<void> login(Login login) async {
    var req = base.post.path("/login").urlEncodedForm(serializers.to(login));
    await req.go();
  }

  Future<void> loginMultipart(Login login) async {
    var req = base.post.path("/login").multipart(
        (serializers.to(login) as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value.toString())));
    await req.go();
  }
}
