# client_cookie

Emulates Cookie store for dart:io and Flutter as if its a Browser.

# Cookies
## Create a cookie

Lets create a cookie named `Client` with value `jaguar_resty`:

```dart
main() {
  var cookie = new ClientCookie('Client', 'jaguar_resty', 
    new DateTime.now());
}
```

## Encoding a cookie

Use `header` getter obtain cookie in String format that can be directly
added to HTTP request:

```dart
main() {
  var cookie = new ClientCookie('Client', 'jaguar_resty', 
    new DateTime.now());
  print(cookie.header);
}
```

## Encoding a bunch of cookies

`ClientCookie` has a static method called `toHeader` that encodes multiple
cookies into a header string:

```dart
main() {
  var cookie1 = new ClientCookie('Client', 'jaguar_resty', new DateTime.now());
  var cookie2 = new ClientCookie('Client', 'jaguar_resty', new DateTime.now());
  print(ClientCookie.toHeader([cookie1, cookie2]));
}
```
