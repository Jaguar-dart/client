# jaguar_http

An HTTP client API generator inspired by Retrofit for Dart.

## Install

```yaml
dependencies:
  jaguar_retrofit:

dev_dependencies:
  jaguar_retrofit_gen:
  build_runner:
```

#### Defining and ApiClient

```dart
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
}
```

#### Generate
`pub run build_runner build`

#### Use it
```dart
  var api = UserApi(base: route("http://localhost:10000"), serializers: repo);
  User user5 = await api
        .createUser(User(id: '5', name: 'five', email: 'five@five.com'));
```
