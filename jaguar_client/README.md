# jaguar_client

Concise JSON client library for Dart and Jaguar based on `package:http`

- Built-in PODO serialization using [`jaguar_serializer`](https://github.com/Jaguar-dart/jaguar_serializer)
- Simple and intuitive API
- Various authentication support
    - JSON authentication
    - url-encoded-form authentication
    - Basic authentication
    - Planned
        - Facebook oauth
        - Google oauth
        - Google 2FA
- Session management
    - Browser: LocalStorage
    - Flutter: SharedPreferences
    - IO: DB, File
- JWT authentication support
- `ResourceClient` to access `DataStore` or a resource
- `SerializedJsonClient` enables writing concise REST calls
- Persistent Cookies on Flutter and IO

# Usage

## Basic requests

GET request:

```dart
final JsonResponse resp =
    await client.get('http://localhost:8080/api/list');
print(resp.body);
```

POST request:

```dart
final JsonResponse resp = await client
    .post('http://localhost:8080/api/map', body: {'posting': 'hello'});
print(resp.body);
```

## Automatic serialization

> TODO

## Authentication

> TODO

## Session management

> TODO

# TODO

-[ ] Persist cookie  
-[ ] Persist auth header?