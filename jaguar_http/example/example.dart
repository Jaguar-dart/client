library jaguar_http.example;

import 'dart:async';
import 'package:http/http.dart';
import 'package:jaguar_http/jaguar_http.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'models/user.dart';
import 'package:jaguar_client/jaguar_client.dart';

part 'example.g.dart';

/// definition
@JaguarHttp()
abstract class UserApi implements ApiClient {
  @GetReq("/users/:id")
  Future<User> getUserById(String id);

  @PostReq("/users")
  Future<User> postUser(@Body() User user);

  @PutReq("/users/:id")
  Future<User> updateUser(String id, @Body() User user);

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
