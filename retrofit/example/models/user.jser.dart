// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.user;

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserSerializer implements Serializer<User> {
  @override
  Map<String, dynamic> toMap(User model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'email', model.email);
    return ret;
  }

  @override
  User fromMap(Map map) {
    if (map == null) return null;
    final obj = User();
    obj.id = map['id'] as String;
    obj.name = map['name'] as String;
    obj.email = map['email'] as String;
    return obj;
  }
}

abstract class _$LoginSerializer implements Serializer<Login> {
  @override
  Map<String, dynamic> toMap(Login model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'username', model.username);
    setMapValue(ret, 'password', model.password);
    return ret;
  }

  @override
  Login fromMap(Map map) {
    if (map == null) return null;
    final obj = Login();
    obj.username = map['username'] as String;
    obj.password = map['password'] as String;
    return obj;
  }
}
