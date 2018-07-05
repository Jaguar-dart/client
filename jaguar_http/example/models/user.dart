library example.user;

import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'user.g.dart';

class User {
  String name;
  String email;
}

@GenSerializer()
class UserSerializer extends Serializer<User> with _$UserSerializer {
  @override
  User createModel() => new User();
}
