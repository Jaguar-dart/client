library example.user;

import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'user.jser.dart';

class User {
  String id;
  String name;
  String email;
  User({this.id, this.name, this.email});

  Map<String, dynamic> toJson() => serializer.toMap(this);

  static final serializer = UserSerializer();
  static User fromMap(Map map) => serializer.fromMap(map);

  String toString() => toJson().toString();
}

@GenSerializer()
class UserSerializer extends Serializer<User> with _$UserSerializer {}

class Login {
  String username;
  String password;
  Login({this.username, this.password});
}

@GenSerializer()
class LoginSerializer extends Serializer<Login> with _$LoginSerializer {}
