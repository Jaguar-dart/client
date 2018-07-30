library jaguar_http.example;

import 'dart:async';
import 'package:http/http.dart';
import 'package:declarative_client/declarative_client.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'models/user.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_client/jaguar_client.dart';
import 'package:jaguar/jaguar.dart';

part 'example.jhttp.dart';

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
class UserApi extends _$UserApiClient implements ApiClient {
  final resty.Route base;

  final SerializerRepo serializers;

  UserApi({this.base, this.serializers});

  @GetReq("/users/:id")
  Future<User> getUserById(String id);

  @PostReq("/users")
  Future<User> postUser(@AsJson() User user);

  @PutReq("/users/:id")
  Future<User> updateUser(String id, @AsJson() User user);

  @DeleteReq("/users/:id")
  Future<void> deleteUser(String id);

  @GetReq("/users")
  Future<List<User>> search({String name, String email});
}

final repo = JsonRepo()..add(UserSerializer());

void server() async {
  final server = Jaguar(port: 10000);
  server.getJson(
      '/users/5', (_) => User(id: "5", name: "Five", email: "five@five.com"));
  await server.serve();
}

void client() async {
  globalClient = IOClient();
  var api = UserApi(base: route("http://localhost:10000"), serializers: repo);

  User user = await api.getUserById("5");
  print(user);
}

main() async {
  await server();
  await client();
}
