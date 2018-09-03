import 'dart:async';
import 'package:auth_header/auth_header.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

abstract class Interceptor {
  const Interceptor();

  FutureOr<void> call(RouteBase route) => before(route);

  FutureOr<void> before(RouteBase route) {
    route.interceptAfter(after);
    return null;
  }

  FutureOr<void> after(Response response);
}

class CookieJar extends Interceptor {
  final store = CookieStore();

  void before(RouteBase r) {
    r.cookies(store.cookies);
    r.interceptAfter(after);
  }

  void after(Response resp) {
    store.addFromHeader(resp.headers['set-cookie']);
  }
}

class BearerToken extends Interceptor {
  String token;

  void before(RouteBase r) {
    if (token != null) r.authToken(token);
    r.interceptAfter(after);
  }

  void after(Response resp) {
    final authHeaders =
        AuthHeaders.fromHeaderStr(resp.headers['authorization']);
    if (authHeaders.containsScheme('Bearer'))
      token = authHeaders.items['Bearer'].credentials;
  }
}
