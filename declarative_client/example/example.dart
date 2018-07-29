library jaguar_http.example;

import 'dart:async';
import 'package:http/http.dart';
import 'package:declarative_client/declarative_client.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'models/user.dart';
import 'package:jaguar_client/jaguar_client.dart';

part 'example.g.dart';

/*
abstract class UserApiImpl implements ApiClient {
  Future<User> getUserById(String id) async {
    var req = base.get.path('/users/:id');
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
 */

/// definition
@GenApiClient()
class UserApi extends UserApiImpl implements ApiClient {
  final Route base;

  final SerializerRepo serializers;

  UserApi({this.base, this.serializers});

  @GetReq("/users/:id")
  Future<User> getUserById(String id);

  @PostReq("/users")
  Future<User> postUser(@ToJson() User user);

  @PutReq("/users/:id")
  Future<User> updateUser(String id, @ToJson() User user);

  @DeleteReq("/users/:id")
  Future<void> deleteUser(String id);

  @GetReq("/users")
  Future<List<User>> search({String name, String email});
}

JsonRepo repo = new JsonRepo()..add(new UserSerializer());

void main() async {
  UserApi
      api /* = new Api(
      client: new IOClient(),
      baseUrl: "http://localhost:9000",
      serializers: repo) */
      /*
    ..requestInterceptors.add((JaguarRequest req) {
      req.headers["Authorization"] = "TOKEN";
      return req;
    }) */
      ;

  User user = await api.getUserById("userId");
  print(user);
}
