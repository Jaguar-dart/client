// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  Future<User> getUserById(String id) async {
    var req = base.get.path("/users/:id");
    await req.go();
  }

  Future<User> postUser(User user) async {
    var req = base.post.path("/users");
    await req.go();
  }

  Future<User> updateUser(String id, User user) async {
    var req = base.put.path("/users/:id");
    await req.go();
  }

  Future<void> deleteUser(String id) async {
    var req = base.delete.path("/users/:id");
    await req.go();
  }

  Future<List<User>> search({String name, String email}) async {
    var req = base.get.path("/users");
    await req.go();
  }
}
