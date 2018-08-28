library jaguar_http.example;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'models/user.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:jaguar/jaguar.dart' as jaguar;

part 'example.jretro.dart';

/// Example showing how to define an [ApiClient]
@GenApiClient()
class UserApi extends _$UserApiClient implements ApiClient {
  final resty.Route base;

  final SerializerRepo serializers;

  UserApi({this.base, this.serializers});

  @GetReq("/users/:id")
  Future<User> getUserById(String id);

  @PostReq("/users")
  Future<User> createUser(@AsJson() User user);

  @PutReq("/users/:id")
  Future<User> updateUser(String id, @AsJson() User user);

  @DeleteReq("/users/:id")
  Future<void> deleteUser(String id);

  @GetReq("/users")
  Future<List<User>> all({String name, String email});

  @PostReq("/login")
  Future<void> login(@AsForm() Login login);
}

final repo = JsonRepo()..add(UserSerializer())..add(LoginSerializer());

void server() async {
  final users = <String, User>{};

  final server = jaguar.Jaguar(port: 10000);
  server.getJson('/users/:id', (c) => users[c.pathParams['id']]);
  server.getJson('/users', (c) => users.values.toList());
  server.postJson('/users', (c) async {
    User user = await c.bodyAsJson(convert: User.fromMap);
    users[user.id] = user;
    return user;
  });
  server.putJson('/users/:id', (c) async {
    User user = await c.bodyAsJson(convert: User.fromMap);
    users[user.id] = user;
    return user;
  });
  server.deleteJson('/users/:id', (c) => users.remove(c.pathParams['id']));
  server.postJson('/user/login', (c) async {
    Map<String, String> body = await c.bodyAsUrlEncodedForm();
    if (body['username'] == "teja" && body["password"] == "pass") {
      c.response = jaguar.Response("Success!");
    } else {
      c.response = jaguar.Response("Failed!", statusCode: 401);
    }
  });
  await server.serve();
}

void client() async {
  globalClient = IOClient();
  var api = UserApi(base: route("http://localhost:10000"), serializers: repo);

  try {
    await api.login(Login(username: 'teja', password: 'pass'));
    User user5 = await api
        .createUser(User(id: '5', name: 'five', email: 'five@five.com'));
    print('Created $user5');
    User user10 =
        await api.createUser(User(id: '10', name: 'ten', email: 'ten@ten.com'));
    print('Created $user10');
    user5 = await api.getUserById("5");
    print('Fetched $user5');
    List<User> users = await api.all();
    print('Fetched all users $users');
    user5 = await api.updateUser(
        '5', User(id: '5', name: 'Five', email: 'five@five.com'));
    print('Updated $user5');
    await api.deleteUser('5');
    users = await api.all();
    print('Deleted user $users');
  } on resty.Response catch (e) {
    print(e.body);
  }
}

main() async {
  await server();
  await client();
  exit(0);
}
