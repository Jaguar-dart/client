// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar_http.example;

// **************************************************************************
// Generator: JaguarHttpGenerator
// **************************************************************************

abstract class UserApiImpl implements ApiClient {
  Future<User> getUserById(String id) async {
    var req = base.get.path('/users/:id').pathParams("id", id);
    return req.one<User>(convert: (Map d) => serializers.oneFrom<User>(d));
  }

  Future<User> postUser(User user) async {
    var req = base.post.path('/users').json(serializers.to(user));
    return req.one<User>(convert: (Map d) => serializers.oneFrom<User>(d));
  }

  Future<User> updateUser(String userId, User user) async {
    var req = base.put.path('/users/:uid').json(serializers.to(user));
    return req.one<User>(convert: (Map d) => serializers.oneFrom<User>(d));
  }

  Future<void> deleteUser(String id) async {
    var req = base.delete.path('/users/:uid');
    return req.go();
  }

  Future<List<User>> search({String name, String email}) async {
    var req = base.get.path('/users').queries({
      'n': name,
      'email': email,
    });
    return req.list<User>(convert: (Map d) => serializers.oneFrom<User>(d));
  }
}
