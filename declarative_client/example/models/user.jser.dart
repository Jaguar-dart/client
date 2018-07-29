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
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'email', model.email);
    return ret;
  }

  @override
  User fromMap(Map map) {
    if (map == null) return null;
    final obj = new User();
    obj.name = map['name'] as String;
    obj.email = map['email'] as String;
    return obj;
  }
}
