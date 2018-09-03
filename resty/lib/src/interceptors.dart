import 'package:auth_header/auth_header.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

class CookieJar {
  final CookieStore store = new CookieStore();
  void intercept(RouteBase r) {
    r.cookies(store.cookies);
    r.interceptAfter(after);
  }

  void after(Response<String> resp) {
    store.addFromHeader(resp.headers['set-cookie']);
  }
}

class BearerToken {
  String token;

  void intercept(RouteBase r) {
    if (token != null) r.authToken(token);
    r.interceptAfter(after);
  }

  void after(Response<String> resp) {
    final authHeaders =
        AuthHeaders.fromHeaderStr(resp.headers['authorization']);
    if (authHeaders.containsScheme('Bearer'))
      token = authHeaders.items['Bearer'].credentials;
  }
}
