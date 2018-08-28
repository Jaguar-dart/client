import 'dart:async';
import 'package:http/http.dart' as ht;
import 'dart:convert' as codec;
import 'expect.dart';
import 'response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:auth_header/auth_header.dart';

typedef void Before(RouteBase route);

Route route(String url) => new Route(url);

Get get(String url) => new Get(url);

Post post(String url) => new Post(url);

Put put(String url) => new Put(url);

Delete delete(String url) => new Delete(url);

OptionsMethod options(String url) => new OptionsMethod(url);

ht.BaseClient globalClient;

class RouteBase {
  RouteBase([String url]) {
    if (url != null) setUrl(url);
  }

  // String _path = '';

  final _paths = <String>[];

  final _pathParams = <String, String>{};

  String _origin;

  Map<String, dynamic /* String | Iterable<String> */ > queryMap = {};

  Map<String, String> headersMap = {};

  Map<String, String> authHeaders = {};

  final List<ClientCookie> _cookies = new List<ClientCookie>();

  final List<Before> before = new List<Before>();
  final List<After<String>> after = <After<String>>[];
  final List<After<String>> successHooks = <After<String>>[];

  ht.BaseClient _client;

  /// Set the [client] used to make HTTP requests
  RouteBase withClient(ht.BaseClient client) {
    _client = client;
    return this;
  }

  RouteBase http(String origin, [String path]) {
    _origin = 'http://${origin}';
    if (path != null) this.path(path);
    return this;
  }

  RouteBase https(String origin, [String path]) {
    _origin = 'https://${origin}';
    if (path != null) this.path(path);
    return this;
  }

  /// Set origin of the URL
  RouteBase origin(String origin, [String path]) {
    _origin = origin;
    if (path != null) this.path(path);
    return this;
  }

  /// Append path segments to the URL
  RouteBase path(String path) {
    if (path.isEmpty) return this;
    final parts = path.split('/').where((p) => p.isNotEmpty);
    _paths.addAll(parts);
    return this;
  }

  RouteBase pathParams(String name, dynamic value) {
    if (value != null) _pathParams[name] = value?.toString();
    return this;
  }

  /// Add query parameters
  RouteBase query(String key, value) {
    queryMap[key] = value.toString();
    return this;
  }

  /// Add query parameters
  RouteBase queries(Map<String, dynamic> value) {
    queryMap.addAll(value);
    return this;
  }

  /// Add headers
  RouteBase header(String key, String value) {
    headersMap[key] = value;
    return this;
  }

  /// Add headers
  RouteBase headers(Map<String, String> values) {
    headersMap.addAll(values);
    return this;
  }

  RouteBase setAuthHeader(String scheme, String credentials) {
    authHeaders[scheme] = credentials;
    return this;
  }

  RouteBase setAuthToken(String credentials) {
    authHeaders['Bearer'] = credentials;
    return this;
  }

  RouteBase setBasicAuth(String username, String password) {
    authHeaders['Basic'] = const codec.Base64Codec.urlSafe()
        .encode('${username}:${password}'.codeUnits);
    return this;
  }

  RouteBase cookie(ClientCookie cookie) {
    _cookies.add(cookie);
    return this;
  }

  RouteBase cookies(List<ClientCookie> cookie) {
    _cookies.addAll(cookie);
    return this;
  }

  RouteBase interceptBefore(Before interceptor) {
    before.add(interceptor);
    return this;
  }

  RouteBase interceptAfter(After<String> interceptor) {
    after.add(interceptor);
    return this;
  }

  RouteBase onSuccess(After<String> callback) {
    successHooks.add(callback);
    return this;
  }

  RouteBase setUrl(String url) {
    final purl = Uri.parse(url);
    if (purl.hasAuthority) origin(purl.origin);
    path(purl.pathSegments.join('/'));
    queries(purl.queryParametersAll);
    return this;
  }

  /// URL
  String get url {
    String path = _paths
        .map((ps) => ps.startsWith(':') ? _pathParams[ps.substring(1)] : ps)
        .join('/');

    path = Uri.encodeFull(path);

    if (_origin == null && queryMap == null) return path;

    final sb = StringBuffer();
    if (_origin != null) sb.write(_origin);
    if (_origin == null || !_origin.endsWith('/')) sb.write('/');
    sb.write(path);
    if (queryMap == null) return sb.toString();
    _makeQueryParams(sb, queryMap);
    return sb.toString();
  }

  static void _makeQueryParams(StringBuffer sb, Map<String, dynamic> query) {
    if (query.length == 0) return;
    sb.write('?');

    void writeQuery(String key, String value, [bool isFirst = false]) {
      if (!isFirst) sb.write('&');
      sb.write(Uri.encodeQueryComponent(key));
      if (value != null && value.isNotEmpty) {
        sb.write("=");
        sb.write(Uri.encodeQueryComponent(value));
      }
    }

    void writeQueries(String key, value, [bool isFirst = false]) {
      if (value is Iterable) {
        for (int i = 0; i < value.length; i++) {
          if (i == 0) {
            writeQuery(key, value.elementAt(i)?.toString() ?? '', isFirst);
          } else {
            writeQuery(key, value.elementAt(i)?.toString() ?? '', false);
          }
        }
        return;
      }
      writeQuery(key, value?.toString() ?? '', isFirst);
    }

    for (int i = 0; i < query.length; i++) {
      String key = query.keys.elementAt(i);
      if (i == 0) {
        writeQueries(key, query[key], true);
      } else {
        writeQueries(key, query[key], false);
      }
    }
  }
}

/// Build fluent REST APIs routes
///
/// Example:
///     route('/book')
///       .query('count', '10')
///       .get.fetchList((m) => new Book.fromMap(m));
class Route extends RouteBase {
  /// Construct [Route] object with [path]
  Route(String url) : super(url);

  /// Converts to [Get] requester
  Get get get => new Get.copy(this);

  /// Converts to [Post] requester
  Post get post => new Post.copy(this);

  /// Converts to [Put] requester
  Put get put => new Put.copy(this);

  /// Converts to [Delete] requester
  Delete get delete => new Delete.copy(this);

  OptionsMethod get options => new OptionsMethod.copy(this);
}

/// Build fluent REST GET APIs
///
/// Example:
///     get('/book')
///       .query('count', '10')
///       .fetchList((m) => new Book.fromMap(m));
class Get extends RouteBase {
  Get(String url) : super(url);

  Get.copy(Route route) {
    _origin = route._origin;
    _paths.addAll(route._paths);
    _pathParams.addAll(route._pathParams);
    queryMap = Map<String, dynamic>.from(route.queryMap);
    headersMap = Map<String, String>.from(route.headersMap);
    authHeaders = Map<String, String>.from(route.authHeaders);
    _client = route._client;
    before.addAll(route.before);
    after.addAll(route.after.toList());
  }

  Get withClient(ht.BaseClient client) => super.withClient(client);

  Get http(String origin, [String path]) => super.http(origin, path);

  Get https(String origin, [String path]) => super.https(origin, path);

  Get origin(String origin, [String path]) => super.origin(origin, path);

  Get path(String path) => super.path(path);

  Get pathParams(String name, dynamic value) => super.pathParams(name, value);

  Get query(String key, value) => super.query(key, value);

  Get queries(Map<String, dynamic> value) => super.queries(value);

  Get header(String key, String value) => super.header(key, value);

  Get headers(Map<String, String> values) => super.headers(values);

  Get setAuthHeader(String scheme, String credentials) =>
      super.setAuthHeader(scheme, credentials);

  Get setAuthToken(String credentials) => super.setAuthToken(credentials);

  Get setBasicAuth(String username, String password) =>
      super.setBasicAuth(username, password);

  Get cookie(ClientCookie cookie) => super.cookie(cookie);

  Get cookies(List<ClientCookie> cookies) => super.cookies(cookies);

  Get interceptBefore(Before interceptor) => super.interceptBefore(interceptor);

  Get interceptAfter(After<String> interceptor) =>
      super.interceptAfter(interceptor);

  Get onSuccess(After<String> callback) => super.onSuccess(callback);

  Get setUrl(String url) => super.setUrl(url);

  AsyncStringResponse go([dynamic then(Response<String> resp)]) {
    for (Before mod in before) mod(this);

    if (_cookies.length != 0)
      headersMap['Cookie'] = ClientCookie.toHeader(_cookies);
    if (authHeaders.isNotEmpty) {
      final auth = new AuthHeaders.fromHeaderStr(headersMap['authorization']);
      for (String scheme in authHeaders.keys) {
        auth.addItem(new AuthHeaderItem(scheme, authHeaders[scheme]));
      }
      headersMap['authorization'] = auth.toString();
    }

    AsyncStringResponse resp = new AsyncStringResponse.from(
        (_client ?? globalClient).get(url, headers: headersMap));
    if (after.isNotEmpty) resp = resp.runAll(after);
    if (successHooks.isNotEmpty) {
      resp = resp.run((r) async {
        if (r.isSuccess) await resp.runAll(successHooks);
      });
    }
    if (then != null) resp = resp.run(then);
    return resp;
  }

  Future<T> one<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decode<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  Future<List<T>> list<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decodeList<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  AsyncStringResponse expect(List<Checker<Response>> conditions) =>
      go().expect(conditions);

  AsyncStringResponse exact(
          {int statusCode,
          String body,
          List<int> bytes,
          String mimeType,
          String encoding,
          Map<String, String> headers,
          int contentLength}) =>
      go().exact(
          statusCode: statusCode,
          body: body,
          bytes: bytes,
          mimeType: mimeType,
          encoding: encoding,
          headers: headers,
          contentLength: contentLength);
}

/// Build fluent REST POST APIs
///
/// Example:
///     post('/book/${id}')
///       .json(book.toMap)
///       .fetch((m) => new Book.fromMap(m));
class Post extends RouteBase {
  dynamic _body;

  Post(String url) : super(url);

  Post.copy(Route route) {
    _origin = route._origin;
    _paths.addAll(route._paths);
    _pathParams.addAll(route._pathParams);
    queryMap = Map<String, dynamic>.from(route.queryMap);
    headersMap = Map<String, String>.from(route.headersMap);
    authHeaders = Map<String, String>.from(route.authHeaders);
    _client = route._client;
    before.addAll(route.before);
    after.addAll(route.after.toList());
  }

  Post withClient(ht.BaseClient client) => super.withClient(client);

  Post http(String origin, [String path]) => super.http(origin, path);

  Post https(String origin, [String path]) => super.https(origin, path);

  Post origin(String origin, [String path]) => super.origin(origin, path);

  Post path(String path) => super.path(path);

  Post pathParams(String name, dynamic value) => super.pathParams(name, value);

  Post query(String key, value) => super.query(key, value);

  Post queries(Map<String, dynamic> value) => super.queries(value);

  Post header(String key, String value) => super.header(key, value);

  Post headers(Map<String, String> values) => super.headers(values);

  Post setAuthHeader(String scheme, String credentials) =>
      super.setAuthHeader(scheme, credentials);

  Post setAuthToken(String credentials) => super.setAuthToken(credentials);

  Post setBasicAuth(String username, String password) =>
      super.setBasicAuth(username, password);

  Post cookie(ClientCookie cookie) => super.cookie(cookie);

  Post cookies(List<ClientCookie> cookies) => super.cookies(cookies);

  Post body(String body) {
    _body = body;
    return this;
  }

  Post json(body, {bool setHeaders: true}) {
    _body = codec.json.encode(body);
    if (setHeaders) {
      header('content-type', 'application/json');
      header('Accept', 'application/json');
    }
    return this;
  }

  Post multipart(Map<String, dynamic> values) {
    if (_body is! Map<String, Multipart>) _body = <String, Multipart>{};
    for (String field in values.keys) {
      dynamic value = values[field];
      if (value is List<int>)
        multipartFile(field, value);
      else if (value is Multipart)
        _body[field] = value;
      else
        multipartField(field, value?.toString() ?? '');
    }
    return this;
  }

  Post multipartField(String field, value) {
    if (_body is! Map<String, Multipart>) _body = <String, Multipart>{};
    _body[field] = MultipartString(value?.toString() ?? '');
    return this;
  }

  Post multipartFile(String field, List<int> value,
      {String filename, MediaType contentType}) {
    if (_body is! Map<String, Multipart>) _body = <String, Multipart>{};
    _body[field] =
        MultipartFile(value, filename: filename, contentType: contentType);
    return this;
  }

  Post multipartStringFile(String field, String value,
      {String filename, MediaType contentType}) {
    if (_body is! Map<String, Multipart>) _body = <String, Multipart>{};
    _body[field] = MultipartStringFile(value,
        filename: filename, contentType: contentType);
    return this;
  }

  Post urlEncodedForm(Map<String, dynamic> values) {
    if (_body is! Map<String, String>) _body = <String, String>{};
    for (String field in values.keys) {
      _body[field] = values[field]?.toString() ?? '';
    }
    return this;
  }

  Post urlEncodedFormField(String name, value) {
    if (_body is! Map<String, String>) _body = <String, String>{};
    _body[name] = value?.toString() ?? '';
    return this;
  }

  Post interceptBefore(Before interceptor) =>
      super.interceptBefore(interceptor);

  Post interceptAfter(After<String> interceptor) =>
      super.interceptAfter(interceptor);

  Post onSuccess(After<String> callback) => super.onSuccess(callback);

  Post setUrl(String url) => super.setUrl(url);

  AsyncStringResponse go([dynamic then(Response<String> resp)]) {
    AsyncStringResponse resp;
    for (Before mod in before) mod(this);

    if (_cookies.length != 0)
      headersMap['Cookie'] = ClientCookie.toHeader(_cookies);
    if (authHeaders.isNotEmpty) {
      final auth = new AuthHeaders.fromHeaderStr(headersMap['authorization']);
      for (String scheme in authHeaders.keys) {
        auth.addItem(new AuthHeaderItem(scheme, authHeaders[scheme]));
      }
      headersMap['authorization'] = auth.toString();
    }

    if (_body is String || _body is Map<String, String> || _body == null) {
      resp = new AsyncStringResponse.from((_client ?? globalClient)
          .post(url, headers: headersMap, body: _body));
    } else if (_body is Map<String, Multipart>) {
      final body = _body as Map<String, Multipart>;
      final r = new ht.MultipartRequest('POST', Uri.parse(url));
      for (final String field in body.keys) {
        final Multipart value = body[field];
        if (value is MultipartString) {
          r.fields[field] = value.value;
        } else if (value is MultipartStringFile) {
          r.files.add(new ht.MultipartFile.fromString(field, value.value,
              filename: value.filename, contentType: value.contentType));
        } else if (value is MultipartFile) {
          r.files.add(new ht.MultipartFile.fromBytes(field, value.value,
              filename: value.filename, contentType: value.contentType));
        }
      }
      r.headers.addAll(headersMap);
      resp = new AsyncStringResponse.from(
          r.send().then((r) => ht.Response.fromStream(r)));
    } else {
      throw new Exception('Invalid body!');
    }
    if (after.isNotEmpty) resp = resp.runAll(after);
    if (successHooks.isNotEmpty) {
      resp = resp.run((r) async {
        if (r.isSuccess) await resp.runAll(successHooks);
      });
    }
    if (then != null) resp = resp.run(then);
    return resp;
  }

  Future<T> one<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decode<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  Future<List<T>> list<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decodeList<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  AsyncStringResponse expect(List<Checker<Response>> conditions) =>
      go().expect(conditions);

  AsyncStringResponse exact(
          {int statusCode,
          String body,
          List<int> bytes,
          String mimeType,
          String encoding,
          Map<String, String> headers,
          int contentLength}) =>
      go().exact(
          statusCode: statusCode,
          body: body,
          bytes: bytes,
          mimeType: mimeType,
          encoding: encoding,
          headers: headers,
          contentLength: contentLength);
}

/// Build fluent REST PUT APIs
///
/// Example:
///     put('/book/${id}')
///       .json(book.toMap)
///       .fetch((m) => new Book.fromMap(m));
class Put extends RouteBase {
  dynamic _body;

  Put(String url) : super(url);

  Put.copy(Route route) {
    _origin = route._origin;
    _paths.addAll(route._paths);
    _pathParams.addAll(route._pathParams);
    queryMap = Map<String, dynamic>.from(route.queryMap);
    headersMap = Map<String, String>.from(route.headersMap);
    authHeaders = Map<String, String>.from(route.authHeaders);
    _client = route._client;
    before.addAll(route.before);
    after.addAll(route.after.toList());
  }

  Put withClient(ht.BaseClient client) => super.withClient(client);

  Put http(String origin, [String path]) => super.http(origin, path);

  Put https(String origin, [String path]) => super.https(origin, path);

  Put origin(String origin, [String path]) => super.origin(origin, path);

  Put path(String path) => super.path(path);

  Put pathParams(String name, dynamic value) => super.pathParams(name, value);

  Put query(String key, value) => super.query(key, value);

  Put queries(Map<String, dynamic> value) => super.queries(value);

  Put header(String key, String value) => super.header(key, value);

  Put headers(Map<String, String> values) => super.headers(values);

  Put setAuthHeader(String scheme, String credentials) =>
      super.setAuthHeader(scheme, credentials);

  Put setAuthToken(String credentials) => super.setAuthToken(credentials);

  Put setBasicAuth(String username, String password) =>
      super.setBasicAuth(username, password);

  Put cookie(ClientCookie cookie) => super.cookie(cookie);

  Put cookies(List<ClientCookie> cookies) => super.cookies(cookies);

  Put body(String body) {
    _body = body;
    return this;
  }

  Put json(body, {bool setHeaders: true}) {
    _body = codec.json.encode(body);
    if (setHeaders) {
      header('content-type', 'application/json');
      header('Accept', 'application/json');
    }
    return this;
  }

  Put multipart(Map<String, dynamic> values) {
    if (_body is! Map<String, Multipart>) _body = <String, Multipart>{};
    for (String field in values.keys) {
      dynamic value = values[field];
      if (value is List<int>)
        multipartFile(field, value);
      else if (value is Multipart)
        _body[field] = value;
      else
        multipartField(field, value?.toString() ?? '');
    }
    return this;
  }

  Put multipartField(String field, value) {
    if (_body is! Map<String, Multipart>) _body = <String, Multipart>{};
    _body[field] = MultipartString(value?.toString() ?? '');
    return this;
  }

  Put multipartFile(String field, List<int> value,
      {String filename, MediaType contentType}) {
    if (_body is! Map<String, Multipart>) _body = <String, Multipart>{};
    _body[field] =
        MultipartFile(value, filename: filename, contentType: contentType);
    return this;
  }

  Put multipartStringFile(String field, String value,
      {String filename, MediaType contentType}) {
    if (_body is! Map<String, Multipart>) _body = <String, Multipart>{};
    _body[field] = MultipartStringFile(value,
        filename: filename, contentType: contentType);
    return this;
  }

  Put urlEncodedForm(Map<String, dynamic> values) {
    if (_body is! Map<String, String>) _body = <String, String>{};
    for (String field in values.keys) {
      _body[field] = values[field]?.toString() ?? '';
    }
    return this;
  }

  Put urlEncodedFormField(String name, value) {
    if (_body is! Map<String, String>) _body = <String, String>{};
    _body[name] = value?.toString() ?? '';
    return this;
  }

  Put interceptBefore(Before interceptor) => super.interceptBefore(interceptor);

  Put interceptAfter(After<String> interceptor) =>
      super.interceptAfter(interceptor);

  Put onSuccess(After<String> callback) => super.onSuccess(callback);

  Put setUrl(String url) => super.setUrl(url);

  AsyncStringResponse go([dynamic then(Response<String> resp)]) {
    for (Before mod in before) mod(this);

    if (_cookies.length != 0)
      headersMap['Cookie'] = ClientCookie.toHeader(_cookies);
    if (authHeaders.isNotEmpty) {
      final auth = new AuthHeaders.fromHeaderStr(headersMap['authorization']);
      for (String scheme in authHeaders.keys) {
        auth.addItem(new AuthHeaderItem(scheme, authHeaders[scheme]));
      }
      headersMap['authorization'] = auth.toString();
    }

    AsyncStringResponse resp;
    if (_body is String || _body is Map<String, String> || _body == null) {
      resp = new AsyncStringResponse.from(
          (_client ?? globalClient).put(url, headers: headersMap, body: _body));
    } else if (_body is Map<String, Multipart>) {
      final body = _body as Map<String, Multipart>;
      final r = new ht.MultipartRequest('PUT', Uri.parse(url));
      for (final String field in body.keys) {
        final Multipart value = body[field];
        if (value is MultipartString) {
          r.fields[field] = value.value;
        } else if (value is MultipartStringFile) {
          r.files.add(new ht.MultipartFile.fromString(field, value.value,
              filename: value.filename, contentType: value.contentType));
        } else if (value is MultipartFile) {
          r.files.add(new ht.MultipartFile.fromBytes(field, value.value,
              filename: value.filename, contentType: value.contentType));
        }
      }
      r.headers.addAll(headersMap);
      resp = new AsyncStringResponse.from(
          r.send().then((r) => ht.Response.fromStream(r)));
    } else {
      throw new Exception('Invalid body!');
    }

    if (after.isNotEmpty) resp = resp.runAll(after);
    if (successHooks.isNotEmpty) {
      resp = resp.run((r) async {
        if (r.isSuccess) await resp.runAll(successHooks);
      });
    }
    if (then != null) resp = resp.run(then);
    return resp;
  }

  Future<T> one<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decode<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  Future<List<T>> list<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decodeList<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  AsyncStringResponse expect(List<Checker<Response>> conditions) =>
      go().expect(conditions);

  AsyncStringResponse exact(
          {int statusCode,
          String body,
          List<int> bytes,
          String mimeType,
          String encoding,
          Map<String, String> headers,
          int contentLength}) =>
      go().exact(
          statusCode: statusCode,
          body: body,
          bytes: bytes,
          mimeType: mimeType,
          encoding: encoding,
          headers: headers,
          contentLength: contentLength);
}

/// Build fluent REST DELETE APIs
///
/// Example:
///     delete('/book/${id}')
///       .fetchList((m) => new Book.fromMap(m));
class Delete extends RouteBase {
  dynamic _body;

  Delete(String url) : super(url);

  Delete.copy(Route route) {
    _origin = route._origin;
    _paths.addAll(route._paths);
    _pathParams.addAll(route._pathParams);
    queryMap = Map<String, dynamic>.from(route.queryMap);
    headersMap = Map<String, String>.from(route.headersMap);
    authHeaders = Map<String, String>.from(route.authHeaders);
    _client = route._client;
    before.addAll(route.before);
    after.addAll(route.after.toList());
  }

  Delete withClient(ht.BaseClient client) => super.withClient(client);

  Delete http(String origin, [String path]) => super.http(origin, path);

  Delete https(String origin, [String path]) => super.https(origin, path);

  Delete origin(String origin, [String path]) => super.origin(origin, path);

  Delete path(String path) => super.path(path);

  Delete pathParams(String name, dynamic value) =>
      super.pathParams(name, value);

  Delete query(String key, value) => super.query(key, value);

  Delete queries(Map<String, dynamic> value) => super.queries(value);

  Delete header(String key, String value) => super.header(key, value);

  Delete headers(Map<String, String> values) => super.headers(values);

  Delete setAuthHeader(String scheme, String credentials) =>
      super.setAuthHeader(scheme, credentials);

  Delete setAuthToken(String credentials) => super.setAuthToken(credentials);

  Delete setBasicAuth(String username, String password) =>
      super.setBasicAuth(username, password);

  Delete cookie(ClientCookie cookie) => super.cookie(cookie);

  Delete cookies(List<ClientCookie> cookies) => super.cookies(cookies);

  Delete interceptBefore(Before interceptor) =>
      super.interceptBefore(interceptor);

  Delete interceptAfter(After<String> interceptor) =>
      super.interceptAfter(interceptor);

  Delete onSuccess(After<String> callback) => super.onSuccess(callback);

  Delete setUrl(String url) => super.setUrl(url);

  AsyncStringResponse go([dynamic then(Response<String> resp)]) {
    for (Before mod in before) mod(this);

    if (_cookies.length != 0)
      headersMap['Cookie'] = ClientCookie.toHeader(_cookies);
    if (authHeaders.isNotEmpty) {
      final auth = new AuthHeaders.fromHeaderStr(headersMap['authorization']);
      for (String scheme in authHeaders.keys) {
        auth.addItem(new AuthHeaderItem(scheme, authHeaders[scheme]));
      }
      headersMap['authorization'] = auth.toString();
    }

    AsyncStringResponse resp = new AsyncStringResponse.from(
        (_client ?? globalClient).delete(url, headers: headersMap));
    if (after.isNotEmpty) resp = resp.runAll(after);
    if (successHooks.isNotEmpty) {
      resp = resp.run((r) async {
        if (r.isSuccess) await resp.runAll(successHooks);
      });
    }
    if (then != null) resp = resp.run(then);
    return resp;
  }

  Future<T> one<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decode<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  Future<List<T>> list<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decodeList<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  AsyncStringResponse expect(List<Checker<Response>> conditions) =>
      go().expect(conditions);

  AsyncStringResponse exact(
          {int statusCode,
          String body,
          List<int> bytes,
          String mimeType,
          String encoding,
          Map<String, String> headers,
          int contentLength}) =>
      go().exact(
          statusCode: statusCode,
          body: body,
          bytes: bytes,
          mimeType: mimeType,
          encoding: encoding,
          headers: headers,
          contentLength: contentLength);
}

/// Build fluent REST DELETE APIs
///
/// Example:
///     options('/book/${id}').go();
class OptionsMethod extends RouteBase {
  dynamic _body;

  OptionsMethod(String url) : super(url);

  OptionsMethod.copy(Route route) {
    _origin = route._origin;
    _paths.addAll(route._paths);
    _pathParams.addAll(route._pathParams);
    queryMap = Map<String, dynamic>.from(route.queryMap);
    headersMap = Map<String, String>.from(route.headersMap);
    authHeaders = Map<String, String>.from(route.authHeaders);
    _client = route._client;
    before.addAll(route.before);
    after.addAll(route.after.toList());
  }

  OptionsMethod withClient(ht.BaseClient client) => super.withClient(client);

  OptionsMethod http(String origin, [String path]) => super.http(origin, path);

  OptionsMethod https(String origin, [String path]) =>
      super.https(origin, path);

  OptionsMethod origin(String origin, [String path]) =>
      super.origin(origin, path);

  OptionsMethod path(String path) => super.path(path);

  OptionsMethod pathParams(String name, dynamic value) =>
      super.pathParams(name, value);

  OptionsMethod query(String key, value) => super.query(key, value);

  OptionsMethod queries(Map<String, dynamic> value) => super.queries(value);

  OptionsMethod header(String key, String value) => super.header(key, value);

  OptionsMethod headers(Map<String, String> values) => super.headers(values);

  OptionsMethod setAuthHeader(String scheme, String credentials) =>
      super.setAuthHeader(scheme, credentials);

  OptionsMethod setAuthToken(String credentials) =>
      super.setAuthToken(credentials);

  OptionsMethod setBasicAuth(String username, String password) =>
      super.setBasicAuth(username, password);

  OptionsMethod cookie(ClientCookie cookie) => super.cookie(cookie);

  OptionsMethod cookies(List<ClientCookie> cookies) => super.cookies(cookies);

  OptionsMethod interceptBefore(Before interceptor) =>
      super.interceptBefore(interceptor);

  OptionsMethod interceptAfter(After<String> interceptor) =>
      super.interceptAfter(interceptor);

  OptionsMethod onSuccess(After<String> callback) => super.onSuccess(callback);

  OptionsMethod setUrl(String url) => super.setUrl(url);

  AsyncStringResponse go([dynamic then(Response<String> resp)]) {
    for (Before mod in before) mod(this);

    if (_cookies.length != 0)
      headersMap['Cookie'] = ClientCookie.toHeader(_cookies);
    if (authHeaders.isNotEmpty) {
      final auth = new AuthHeaders.fromHeaderStr(headersMap['authorization']);
      for (String scheme in authHeaders.keys) {
        auth.addItem(new AuthHeaderItem(scheme, authHeaders[scheme]));
      }
      headersMap['authorization'] = auth.toString();
    }

    final req = new ht.Request('OPTIONS', Uri.parse(url));
    req.headers.addAll(headersMap);

    AsyncStringResponse resp = new AsyncStringResponse.from(
        (_client ?? globalClient)
            .send(req)
            .then((r) => ht.Response.fromStream(r)));
    if (after.isNotEmpty) resp = resp.runAll(after);
    if (successHooks.isNotEmpty) {
      resp = resp.run((r) async {
        if (r.isSuccess) await resp.runAll(successHooks);
      });
    }
    if (then != null) resp = resp.run(then);
    return resp;
  }

  Future<T> one<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decode<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  Future<List<T>> list<T>(
      {T convert(Map d),
      FutureOr<dynamic> onError(StringResponse resp)}) async {
    StringResponse resp = await go();
    if (resp.statusCode >= 200 && resp.statusCode < 300)
      return resp.decodeList<T>(convert);
    if (onError == null) throw ErrorResponse(resp);
    var err = await onError(resp);
    if (err != null) throw err;
    return null;
  }

  AsyncStringResponse expect(List<Checker<Response>> conditions) =>
      go().expect(conditions);

  AsyncStringResponse exact(
          {int statusCode,
          String body,
          List<int> bytes,
          String mimeType,
          String encoding,
          Map<String, String> headers,
          int contentLength}) =>
      go().exact(
          statusCode: statusCode,
          body: body,
          bytes: bytes,
          mimeType: mimeType,
          encoding: encoding,
          headers: headers,
          contentLength: contentLength);
}

abstract class Multipart {}

class MultipartString implements Multipart {
  final String value;

  MultipartString(this.value);
}

class MultipartFile implements Multipart {
  final String filename;

  final MediaType contentType;

  final List<int> value;

  MultipartFile(this.value, {this.filename, this.contentType});
}

class MultipartStringFile implements Multipart {
  final String filename;

  final MediaType contentType;

  final String value;

  MultipartStringFile(this.value, {this.filename, this.contentType});
}

class ErrorResponse {
  final Response response;

  ErrorResponse(this.response);

  int get statusCode => response.statusCode;

  String get body => response.body;

  String toString() => 'Http error! Status code: $statusCode body: $body';
}
