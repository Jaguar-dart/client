part of http.json;

class AuthPayload {
  final String username, password;

  final Map<String, dynamic> extras;

  AuthPayload(this.username, this.password, {this.extras});

  Map<String, dynamic> toMap() {
    final ret = {
      'username': username,
      'password': password,
    };
    if (extras is Map) ret.addAll(extras);
    return ret;
  }
}
