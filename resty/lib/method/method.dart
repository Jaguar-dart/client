import 'dart:async';
import 'package:http/http.dart' as ht;
import 'dart:convert' as codec;
import 'package:jaguar_resty/expect/expect.dart';
import 'package:jaguar_resty/response/response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:auth_header/auth_header.dart';
import 'package:jaguar_resty/method/uri_builder.dart';

import 'multipart.dart';

export 'multipart.dart';

typedef FutureOr<void> Before(Method route);

/// Build fluent REST GET APIs
///
/// Example:
///     get('/book')
///       .query('count', '10')
///       .fetchList((m) => Book.fromMap(m));
Method get(dynamic? /* String | Uri | MutUri */ url) =>
    Method(method: 'GET', uri: url);

/// Build fluent REST DELETE APIs
///
/// Example:
///     delete('/book/${id}')
///       .fetchList((m) => Book.fromMap(m));
Method delete(dynamic? /* String | Uri | MutUri */ url) =>
    Method(method: 'DELETE', uri: url);

/// Build fluent REST OPTIONS APIs
///
/// Example:
///     options('/book/${id}').go();
Method options(dynamic? /* String | Uri | MutUri */ url) =>
    Method(method: 'OPTIONS', uri: url);

/// Build fluent REST POST APIs
///
/// Example:
///     post('/book/${id}')
///       .json(book.toMap)
///       .fetch((m) => Book.fromMap(m));
MethodWithBody post(dynamic? /* String | Uri | MutUri */ url) =>
    MethodWithBody(method: 'POST', uri: url);

/// Build fluent REST PATCH APIs
///
/// Example:
///     patch('/book/${id}')
///       .json(book.toMap)
///       .fetch((m) => Book.fromMap(m));
MethodWithBody patch(dynamic? /* String | Uri | MutUri */ url) =>
    MethodWithBody(method: 'PATCH', uri: url);

/// Build fluent REST PUT APIs
///
/// Example:
///     put('/book/${id}')
///       .json(book.toMap)
///       .fetch((m) => Book.fromMap(m));
MethodWithBody put(dynamic? /* String | Uri | MutUri */ url) =>
    MethodWithBody(method: 'PUT', uri: url);

ht.BaseClient? globalClient;

class Method {
  String method;
  final getMetadata = <String, dynamic>{};
  final getHeaders = <String, String>{};
  final getAuthHeaders = <String, String>{};
  final getCookies = <ClientCookie>[];
  final getBefore = <Before>[];
  final getAfter = <After>[];
  ht.BaseClient? getClient;
  MutUri uri = MutUri();

  Method({
    this.method = 'GET',
    dynamic? /* String | Uri | MutUri */ uri,
    Map<String, String> headers = const {},
    Map<String, String> authHeaders = const {},
    List<ClientCookie> cookies = const [],
    List<Before> before = const [],
    List<After> after = const [],
    Map<String, dynamic> metadata = const {},
    ht.BaseClient? client,
  }) : getClient = client {
    if (uri != null) {
      this.uri = MutUri.from(uri);
    }

    getMetadata.addAll(metadata);
    getHeaders.addAll(headers);
    getAuthHeaders.addAll(authHeaders);
    getCookies.addAll(cookies);
    getBefore.addAll(before);
    getAfter.addAll(after);
  }

  Method clone() {
    final ret = Method(
      method: method,
      headers: getHeaders,
      authHeaders: getAuthHeaders,
      cookies: getCookies,
      before: getBefore,
      after: getAfter,
      metadata: getMetadata,
      client: getClient,
    );
    ret.uri = uri.clone();

    return ret;
  }

  /// Set the [client] used to make HTTP requests
  Method withClient(ht.BaseClient client) {
    getClient = client;
    return this;
  }

  Method http(String origin, [String? path]) {
    uri.http(origin, path);
    return this;
  }

  Method https(String origin, [String? path]) {
    uri.https(origin, path);
    return this;
  }

  /// Set origin of the URL
  Method origin(String origin, [String? path]) {
    uri.origin(origin, path);
    return this;
  }

  /// Append path segments to the URL
  Method path(String path) {
    uri.path(path);
    return this;
  }

  Method pathParam(String name, dynamic value) {
    uri.pathParam(name, value);
    return this;
  }

  Method pathParams(Map<String, dynamic> pathParams) {
    uri.pathParams(pathParams);
    return this;
  }

  /// Add query parameters
  Method query(String key, value) {
    uri.query(key, value);
    return this;
  }

  /// Add query parameters
  Method queries(Map<String, dynamic> value) {
    uri.queries(value);
    return this;
  }

  /// Add headers
  Method header(String key, String value) {
    getHeaders[key.toLowerCase()] = value;
    return this;
  }

  /// Add headers
  Method headers(Map<String, String> values) {
    getHeaders.addAll(values.map((k, v) => MapEntry(k.toLowerCase(), v)));
    return this;
  }

  Method mimeType(String mimeType) {
    final mt = MediaType.parse(getHeaders['content-type'] ?? 'text/plain');
    header('content-type', mt.change(mimeType: mimeType).toString());
    return this;
  }

  Method charset(String charset) {
    final mt = MediaType.parse(getHeaders['content-type'] ?? 'text/plain');
    header(
        'content-type', mt.change(parameters: {'charset': charset}).toString());
    return this;
  }

  Method contentType(String mimeType, String charset) {
    final mt = MediaType.parse(getHeaders['content-type'] ?? 'text/plain');
    header(
        'content-type',
        mt.change(
            mimeType: mimeType, parameters: {'charset': charset}).toString());
    return this;
  }

  Method authHeader(String scheme, String credentials) {
    getAuthHeaders[scheme] = credentials;
    return this;
  }

  Method authToken(String credentials) {
    getAuthHeaders['Bearer'] = credentials;
    return this;
  }

  Method basicAuth(String username, String password) {
    getAuthHeaders['Basic'] = const codec.Base64Codec.urlSafe()
        .encode('${username}:${password}'.codeUnits);
    return this;
  }

  Method cookie(ClientCookie cookie) {
    getCookies.add(cookie);
    return this;
  }

  Method cookies(List<ClientCookie> cookie) {
    getCookies.addAll(cookie);
    return this;
  }

  Method before(Before interceptor) {
    getBefore.add(interceptor);
    return this;
  }

  Method after(After interceptor) {
    getAfter.add(interceptor);
    return this;
  }

  Method metadata(Map<String, dynamic> value) {
    getMetadata.addAll(value);
    return this;
  }

  Method hookHeader(String key, ValueCallback<String?> getter) {
    getAfter.add((r) => getter(r.headers[key]));
    return this;
  }

  Method url(String value) {
    uri = MutUri.from(value);
    return this;
  }

  Future<ht.Response> _send() async {
    for (Before mod in getBefore) {
      await mod(this);
    }
    _prepare(this);

    final req = ht.Request(method, uri.uri);
    req.headers.addAll(getHeaders);
    return (getClient ?? globalClient)!
        .send(req)
        .then((r) => ht.Response.fromStream(r));
  }

  Future<ht.Response> go(
      {ResponseHook? onSuccess,
      ResponseHook? onFailure,
      bool throwOnErr = false,
      Map<String, dynamic> pathParams = const {}}) async {
    final cloned = clone();
    cloned.pathParams(pathParams);
    ht.Response ret = await cloned._send();
    for (After func in cloned.getAfter) {
      ht.Response? res = await func(ret);
      if (res != null) {
        ret = res;
      }
    }

    if (onSuccess != null) {
      if (ret.isSuccess) {
        await onSuccess(ret);
      }
    }

    if (onFailure != null) {
      if (ret.isFailure) {
        await onFailure(ret);
      }
    }

    if (throwOnErr) {
      if (ret.isFailure) {
        throw ret;
      }
    }

    return ret;
  }

  Future<List<int>?> readBytes(
      {Map<String, dynamic> pathParams = const {},
      FutureOr<dynamic> onError(ht.Response resp)?}) async {
    ht.Response resp = await go(pathParams: pathParams);
    if (resp.isSuccess) {
      return resp.bodyBytes;
    }

    if (onError == null) {
      throw ErrorResponse(resp);
    }
    var err = await onError(resp);
    if (err != null) {
      throw err;
    }
    return null;
  }

  Future<String?> readString(
      {Map<String, dynamic> pathParams = const {},
      FutureOr<dynamic> onError(ht.Response resp)?}) async {
    ht.Response resp = await go(pathParams: pathParams);
    if (resp.isSuccess) {
      return resp.body;
    }

    if (onError == null) {
      throw ErrorResponse(resp);
    }
    var err = await onError(resp);
    if (err != null) {
      throw err;
    }
    return null;
  }

  /// Fetches json response and returns the decoded result
  Future<T?> readOne<T>(
      {T convert(Map d)?,
      Map<String, dynamic> pathParams = const {},
      FutureOr<dynamic> onError(ht.Response resp)?}) async {
    ht.Response resp = await go(pathParams: pathParams);
    if (resp.isSuccess) {
      return resp.json<T>(convert);
    }

    if (onError == null) {
      throw ErrorResponse(resp);
    }
    var err = await onError(resp);
    if (err != null) {
      throw err;
    }
    return null;
  }

  /// Fetches json response and returns the decoded result
  Future<List<T>?> readList<T>(
      {T convert(Map d)?,
      Map<String, dynamic> pathParams = const {},
      FutureOr<dynamic> onError(ht.Response resp)?}) async {
    ht.Response resp = await go(pathParams: pathParams);
    if (resp.isSuccess) {
      return resp.jsonList<T>(convert);
    }
    if (onError == null) {
      throw ErrorResponse(resp);
    }
    var err = await onError(resp);
    if (err != null) {
      throw err;
    }
    return null;
  }

  Future<ht.Response> expect(List<Checker<ht.Response>> conditions,
      {Map<String, dynamic> pathParams = const {}}) async {
    final resp = await go(pathParams: pathParams);
    resp.expect(conditions);
    return resp;
  }

  Future<ht.Response> exact({
    int? statusCode,
    String? body,
    List<int>? bytes,
    String? mimeType,
    String? encoding,
    Map<String, String>? headers,
    int? contentLength,
    Map<String, dynamic> pathParams = const {},
  }) async {
    final resp = await go(pathParams: pathParams);
    resp.exact(
      statusCode: statusCode,
      body: body,
      bytes: bytes,
      mimeType: mimeType,
      encoding: encoding,
      headers: headers,
      contentLength: contentLength,
    );
    return resp;
  }
}

// TODO this should be removed. operate directly on header string
void _prepare(Method route) {
  if (route.getCookies.length != 0)
    route.getHeaders['Cookie'] = ClientCookie.toSetCookie(route.getCookies);
  if (route.getAuthHeaders.isNotEmpty) {
    final auth = AuthHeaders.fromHeaderStr(route.getHeaders['authorization']);
    for (String scheme in route.getAuthHeaders.keys) {
      auth.addItem(AuthHeaderItem(scheme, route.getAuthHeaders[scheme]!));
    }
    route.getHeaders['authorization'] = auth.toString();
  }
}

class MethodWithBody extends Method {
  dynamic _body;

  MethodWithBody({
    String method = 'POST',
    dynamic? /* String | Uri | MutUri */ uri,
    Map<String, String> headers = const {},
    Map<String, String> authHeaders = const {},
    List<ClientCookie> cookies = const [],
    List<Before> before = const [],
    List<After> after = const [],
    Map<String, dynamic> metadata = const {},
    ht.BaseClient? client,
    dynamic body,
  }) : super(
            method: method,
            uri: uri,
            headers: headers,
            authHeaders: authHeaders,
            cookies: cookies,
            before: before,
            after: after,
            metadata: metadata,
            client: client) {
    _body = body;
    // Do nothing
  }

  MethodWithBody clone() {
    final ret = MethodWithBody(
      method: method,
      headers: getHeaders,
      authHeaders: getAuthHeaders,
      cookies: getCookies,
      before: getBefore,
      after: getAfter,
      metadata: getMetadata,
      client: getClient,
      body: _body,
    );
    ret.uri = uri.clone();

    return ret;
  }

  dynamic get getBody => _body;

  MethodWithBody body(dynamic body) {
    if (body is List<int>) {
      _body = body;
    } else {
      _body = body?.toString();
    }
    return this;
  }

  MethodWithBody json(body, {bool setHeaders: true}) {
    _body = codec.json.encode(body);
    if (setHeaders) {
      mimeType('application/json');
      header('Accept', 'application/json');
    }
    return this;
  }

  MethodWithBody multipart(Map<String, dynamic> values) {
    if (_body is! Map<String, Multipart>) {
      _body = <String, Multipart>{};
    }

    for (String field in values.keys) {
      dynamic value = values[field];
      if (value is List<int>) {
        multipartFile(field, value);
      } else if (value is Multipart) {
        _body[field] = value;
      } else {
        multipartField(field, value);
      }
    }

    return this;
  }

  MethodWithBody multipartField(String field, value) {
    if (_body is! Map<String, Multipart>) {
      _body = <String, Multipart>{};
    }
    if (value != null) {
      _body[field] = MultipartString(value!.toString());
    }
    return this;
  }

  MethodWithBody multipartFile(String field, List<int>? value,
      {String? filename, MediaType? contentType}) {
    if (_body is! Map<String, Multipart>) {
      _body = <String, Multipart>{};
    }
    if (value != null) {
      _body[field] =
          MultipartFile(value, filename: filename, contentType: contentType);
    }
    return this;
  }

  MethodWithBody multipartStringFile(String field, String? value,
      {String? filename, MediaType? contentType}) {
    if (_body is! Map<String, Multipart>) {
      _body = <String, Multipart>{};
    }
    if (value != null) {
      _body[field] = MultipartStringFile(value,
          filename: filename, contentType: contentType);
    }
    return this;
  }

  MethodWithBody urlEncodedForm(Map<String, dynamic> values) {
    if (_body is! Map<String, String>) {
      _body = <String, String>{};
    }
    for (String field in values.keys) {
      if (values[field] != null) {
        _body[field] = values[field]?.toString();
      }
    }
    return this;
  }

  MethodWithBody urlEncodedFormField(String name, value) {
    if (_body is! Map<String, String>) {
      _body = <String, String>{};
    }
    if (value != null) {
      _body[name] = value?.toString();
    }
    return this;
  }

  /// Set the [client] used to make HTTP requests
  MethodWithBody withClient(ht.BaseClient client) {
    super.withClient(client);
    return this;
  }

  MethodWithBody http(String origin, [String? path]) {
    super.http(origin, path);
    return this;
  }

  MethodWithBody https(String origin, [String? path]) {
    super.https(origin, path);
    return this;
  }

  /// Set origin of the URL
  MethodWithBody origin(String origin, [String? path]) {
    super.origin(origin, path);
    return this;
  }

  /// Append path segments to the URL
  MethodWithBody path(String path) {
    super.path(path);
    return this;
  }

  MethodWithBody pathParam(String name, dynamic value) {
    super.pathParam(name, value);
    return this;
  }

  MethodWithBody pathParams(Map<String, dynamic> pathParams) {
    super.pathParams(pathParams);
    return this;
  }

  /// Add query parameters
  MethodWithBody query(String key, value) {
    super.query(key, value);
    return this;
  }

  /// Add query parameters
  MethodWithBody queries(Map<String, dynamic> value) {
    super.queries(value);
    return this;
  }

  /// Add headers
  MethodWithBody header(String key, String value) {
    super.header(key, value);
    return this;
  }

  /// Add headers
  MethodWithBody headers(Map<String, String> values) {
    super.headers(values);
    return this;
  }

  MethodWithBody mimeType(String mimeType) {
    super.mimeType(mimeType);
    return this;
  }

  MethodWithBody charset(String charset) {
    super.charset(charset);
    return this;
  }

  MethodWithBody contentType(String mimeType, String charset) {
    super.contentType(mimeType, charset);
    return this;
  }

  MethodWithBody authHeader(String scheme, String credentials) {
    super.authHeader(scheme, credentials);
    return this;
  }

  MethodWithBody authToken(String credentials) {
    super.authToken(credentials);
    return this;
  }

  MethodWithBody basicAuth(String username, String password) {
    super.basicAuth(username, password);
    return this;
  }

  MethodWithBody cookie(ClientCookie cookie) {
    super.cookie(cookie);
    return this;
  }

  MethodWithBody cookies(List<ClientCookie> cookie) {
    super.cookies(cookie);
    return this;
  }

  MethodWithBody before(Before interceptor) {
    super.before(interceptor);
    return this;
  }

  MethodWithBody after(After interceptor) {
    super.after(interceptor);
    return this;
  }

  MethodWithBody metadata(Map<String, dynamic> value) {
    super.metadata(value);
    return this;
  }

  MethodWithBody hookHeader(String key, ValueCallback<String?> getter) {
    super.hookHeader(key, getter);
    return this;
  }

  MethodWithBody url(String value) {
    super.url(value);
    return this;
  }

  ht.BaseRequest _makeRequest() {
    if (_body is String || _body == null) {
      final req = ht.Request(method, uri.uri);
      if (_body != null) {
        req.body = _body;
      }
      req.headers.addAll(getHeaders);
      return req;
    } else if (_body is List<int>) {
      final req = ht.Request(method, uri.uri);
      req.bodyBytes = _body;
      req.headers.addAll(getHeaders);
      return req;
    } else if (_body is Map<String, String>) {
      final req = ht.Request(method, uri.uri);
      req.bodyFields = _body;
      req.headers.addAll(getHeaders);
      return req;
    } else if (_body is Map<String, Multipart>) {
      final body = _body as Map<String, Multipart>;
      final r = ht.MultipartRequest('POST', uri.uri);
      for (final String field in body.keys) {
        final Multipart value = body[field]!;
        if (value is MultipartString) {
          r.fields[field] = value.value;
        } else if (value is MultipartStreamFile) {
          r.files.add(ht.MultipartFile(field, value.value, value.length,
              filename: value.filename, contentType: value.contentType));
        } else if (value is MultipartFile) {
          r.files.add(ht.MultipartFile.fromBytes(field, value.value,
              filename: value.filename, contentType: value.contentType));
        } else if (value is MultipartStringFile) {
          r.files.add(ht.MultipartFile.fromString(field, value.value,
              filename: value.filename, contentType: value.contentType));
        }
      }
      r.headers.addAll(getHeaders);
      return r;
    } else {
      throw Exception('Invalid body!');
    }
  }

  Future<ht.Response> _send() async {
    for (Before mod in getBefore) {
      await mod(this);
    }

    _prepare(this);

    final req = _makeRequest();
    return (getClient ?? globalClient)!
        .send(req)
        .then((resp) => ht.Response.fromStream(resp));
  }
}

class ErrorResponse {
  final ht.Response response;

  ErrorResponse(this.response);

  int get statusCode => response.statusCode;

  String get body => response.body;

  String toString() => 'Http error! Status code: $statusCode body: $body';
}

typedef ValueCallback<T> = void Function(T value);
