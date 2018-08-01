# jaguar_http

An Http Api generator inspired by Retrofit for Dart

# TODO

+ Header Map
+ Query Map
+ UrlEncodedForm
+ Multipart form

## Install

`pub global activate jaguar_http_cli`

## Usage

A simple usage example:

#### pubspec.yaml

```yaml
jaguar_http:
  - example/example.dart
```

#### Defining and ApiClient

```dart
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


#### run
`jaguar_http build`

#### use it
```dart
final api = new Api(new IOClient(), "http://localhost:9000", serializers: repo);
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
