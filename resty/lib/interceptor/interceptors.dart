import 'dart:async';
import 'package:auth_header/auth_header.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

abstract class Interceptor {
  const Interceptor();

  FutureOr<void> call(RouteBase route) => before(route);

  FutureOr<void> before(RouteBase route) {
    route.after(after);
    return null;
  }

  FutureOr<dynamic> after(StringResponse response);
}

class CookieJar extends Interceptor {
  final store = CookieStore();

  void before(RouteBase r) {
    r.cookies(store.cookies);
    r.after(after);
  }

  StringResponse after(StringResponse resp) {
    store.addFromHeader(resp.headers['set-cookie']);
    return null;
  }
}

class BearerToken extends Interceptor {
  String token;

  void before(RouteBase r) {
    if (token != null) r.authToken(token);
    r.after(after);
  }

  StringResponse after(StringResponse resp) {
    final authHeaders =
        AuthHeaders.fromHeaderStr(resp.headers['authorization']);
    if (authHeaders.containsScheme('Bearer'))
      token = authHeaders.items['Bearer'].credentials;
    return null;
  }
}
