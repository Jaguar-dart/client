import 'dart:async';
import 'package:meta/meta.dart';
import 'dart:convert' as codec;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/expect/expect.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:jaguar_resty/routes/routes.dart';

import 'package:client_cookie/client_cookie.dart';

typedef FutureOr<dynamic> After(StringResponse response);

typedef FutureOr ResponseHook<T>(Response<T> response);

abstract class AsyncResponse<BT> {
  FutureOr<int> get statusCode;

  FutureOr<bool> get isSuccess;

  FutureOr<bool> get isFailure;

  FutureOr<BT> get body;

  FutureOr<List<int>> get bytes;

  FutureOr<Map<String, String>> get headers;

  FutureOr<bool> get isRedirect;

  FutureOr<bool> get persistentConnection;

  FutureOr<String> get reasonPhrase;

  FutureOr<int> get contentLength;

  FutureOr<http.BaseRequest> get request;

  FutureOr<RouteBase> get sender;

  FutureOr<RouteBase> get sent;

  FutureOr<String> get mimeType;

  FutureOr<String> get encoding;

  FutureOr<StringResponse> get toStringResponse;

  Future<Response<BT>> onSuccess(ResponseHook<BT> hook);

  Future<Response<BT>> onFailure(ResponseHook<BT> hook);

  AsyncResponse<BT> expect(List<Checker<Response>> conditions);

  AsyncResponse<BT> exact(
      {int statusCode,
      BT body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength});

  AsyncResponse<BT> run(ResponseHook<BT> func);

  FutureOr<T> map<T>(FutureOr<T> func(Response<BT> resp));
}

class AsyncTResponse<BT> extends DelegatingFuture<Response<BT>>
    implements AsyncResponse<BT> {
  AsyncTResponse(Future<Response<BT>> inner) : super(inner);

  Future<int> get statusCode => then((r) => r.statusCode);

  Future<BT> get body => then((r) => r.body);

  Future<List<int>> get bytes => then((r) => r.bytes);

  Future<Map<String, String>> get headers => then((r) => r.headers);

  Future<bool> get isRedirect => then((r) => r.isRedirect);

  Future<bool> get persistentConnection => then((r) => r.persistentConnection);

  Future<String> get reasonPhrase => then((r) => r.reasonPhrase);

  Future<int> get contentLength => then((r) => r.contentLength);

  Future<http.BaseRequest> get request => then((r) => r.request);

  Future<RouteBase> get sender => then((r) => r.sender);

  Future<RouteBase> get sent => then((r) => r.sent);

  Future<String> get mimeType => then((r) => r.mimeType);

  Future<String> get encoding => then((r) => r.encoding);

  Future<bool> get isSuccess => then((r) => r.isSuccess);

  Future<bool> get isFailure => then((r) => r.isFailure);

  AsyncStringResponse get toStringResponse => then((r) => r.toStringResponse);

  AsyncTResponse<BT> onSuccess(ResponseHook<BT> hook) =>
      run((Response<BT> r) => r.onSuccess(hook));

  AsyncTResponse<BT> onFailure(ResponseHook<BT> hook) =>
      run((Response<BT> r) => r.onFailure(hook));

  AsyncTResponse<BT> expect(List<Checker<Response>> conditions) {
    return AsyncTResponse<BT>(then((r) => r.expect(conditions)));
  }

  AsyncTResponse<BT> exact(
      {int statusCode,
      BT body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength}) {
    return AsyncTResponse<BT>(then((r) {
      r.exact(
          statusCode: statusCode,
          body: body,
          bytes: bytes,
          mimeType: mimeType,
          encoding: encoding,
          headers: headers,
          contentLength: contentLength);
    }));
  }

  /// Runs [func] with [Response] object after request completion
  AsyncTResponse<BT> run(ResponseHook<BT> func) =>
      AsyncTResponse<BT>(then((r) async {
        await func(r);
        return r;
      }));

  Future<T> map<T>(FutureOr<T> func(Response<BT> resp)) async {
    final resp = await this;
    return func(resp);
  }
}

class AsyncStringResponse extends DelegatingFuture<StringResponse>
    implements AsyncResponse<String> {
  AsyncStringResponse(Future<StringResponse> inner) : super(inner);

  AsyncStringResponse.from(Future<http.Response> inner,
      {@required RouteBase sender, @required RouteBase sent})
      : super(inner
            .then((r) => StringResponse.from(r, sender: sender, sent: sent)));

  Future<int> get statusCode => then((r) => r.statusCode);

  Future<String> get body => then((r) => r.body);

  Future<List<int>> get bytes => then((r) => r.bytes);

  Future<Map<String, String>> get headers => then((r) => r.headers);

  Future<bool> get isRedirect => then((r) => r.isRedirect);

  Future<bool> get persistentConnection => then((r) => r.persistentConnection);

  Future<String> get reasonPhrase => then((r) => r.reasonPhrase);

  Future<int> get contentLength => then((r) => r.contentLength);

  Future<http.BaseRequest> get request => then((r) => r.request);

  Future<String> get mimeType => then((r) => r.mimeType);

  Future<String> get encoding => then((r) => r.encoding);

  Future<bool> get isSuccess => then((r) => r.isSuccess);

  Future<bool> get isFailure => then((r) => r.isFailure);

  Future<RouteBase> get sender => then((r) => r.sender);

  Future<RouteBase> get sent => then((r) => r.sent);

  AsyncStringResponse get toStringResponse => this;

  AsyncStringResponse onSuccess(ResponseHook<String> hook) =>
      run((Response<String> r) => r.onSuccess(hook));

  AsyncStringResponse onFailure(ResponseHook<String> hook) =>
      run((Response<String> r) => r.onFailure(hook));

  AsyncStringResponse expect(List<Checker<Response>> conditions) {
    return AsyncStringResponse(then((r) => r.expect(conditions)));
  }

  AsyncStringResponse exact(
      {int statusCode,
      String body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength}) {
    return AsyncStringResponse(then((r) => r.exact(
        statusCode: statusCode,
        body: body,
        bytes: bytes,
        mimeType: mimeType,
        encoding: encoding,
        headers: headers,
        contentLength: contentLength)));
  }

  AsyncTResponse<T> json<T>([T convert(Map d)]) =>
      AsyncTResponse<T>(then((StringResponse r) => r.json<T>(convert)));

  AsyncTResponse<List<T>> jsonList<T>([T convert(Map d)]) =>
      AsyncTResponse<List<T>>(
          then((StringResponse r) => r.jsonList<T>(convert)));

  Future<T> decodeJson<T>([T convert(Map d)]) =>
      then((r) => r.decodeJson<T>(convert));

  Future<List<T>> decodeJsonList<T>([T convert(Map d)]) =>
      then((StringResponse r) => r.decodeJsonList<T>(convert));

  /// Runs [func] with [Response] object after request completion
  AsyncStringResponse run(ResponseHook<String> func) =>
      AsyncStringResponse(then((r) async {
        await func(r);
        return r;
      }));

  Future<T> map<T>(FutureOr<T> func(StringResponse resp)) async {
    final resp = await this;
    return func(resp);
  }
}

abstract class Response<T> implements AsyncResponse<T> {
  int get statusCode;

  bool get isSuccess;

  bool get isFailure;

  T get body;

  List<int> get bytes;

  Map<String, String> get headers;

  bool get isRedirect;

  bool get persistentConnection;

  String get reasonPhrase;

  int get contentLength;

  http.BaseRequest get request;

  RouteBase get sender;

  RouteBase get sent;

  String get mimeType;

  String get encoding;

  Future<Response<T>> onSuccess(ResponseHook<T> hook);

  Future<Response<T>> onFailure(ResponseHook<T> hook);

  Response<T> expect(List<Checker<Response>> conditions);

  Response<T> exact(
      {int statusCode,
      T body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength});

  StringResponse get toStringResponse;

  static const String defaultContentType =
      'application/octet-stream;charset=utf-8';
  static const String defaultCharset = 'utf-8';
}

class TResponse<BT> implements Response<BT> {
  final int statusCode;

  final BT body;

  final List<int> bytes;

  final Map<String, String> headers;

  final bool isRedirect;

  final bool persistentConnection;

  final String reasonPhrase;

  final int contentLength;

  final http.BaseRequest request;

  final RouteBase sender;

  final RouteBase sent;

  final String mimeType;

  final String encoding;

  TResponse(
      {this.statusCode,
      this.body,
      this.bytes,
      this.headers,
      this.isRedirect,
      this.persistentConnection,
      this.reasonPhrase,
      this.contentLength,
      this.request,
      @required this.sender,
      @required this.sent,
      this.mimeType,
      this.encoding});

  StringResponse get toStringResponse => StringResponse(
      statusCode: statusCode,
      mimeType: mimeType,
      headers: headers,
      bytes: bytes,
      contentLength: contentLength,
      encoding: encoding,
      isRedirect: isRedirect,
      request: request,
      sender: sender,
      sent: sent,
      persistentConnection: persistentConnection,
      reasonPhrase: reasonPhrase);

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  bool get isFailure => statusCode >= 400 && statusCode < 600;

  Future<TResponse<BT>> onSuccess(ResponseHook<BT> func) async {
    if (isSuccess) await func(this);
    return this;
  }

  Future<TResponse<BT>> onFailure(ResponseHook<BT> func) async {
    if (isFailure) await func(this);
    return this;
  }

  TResponse<BT> expect(List<Checker<Response>> conditions) {
    final mismatches = conditions
        .map((c) => c(this))
        .reduce((List<Mismatch> v, List<Mismatch> e) => v..addAll(e))
        .toList();
    if (mismatches.length != 0) throw mismatches;
    return this;
  }

  TResponse<BT> exact(
      {int statusCode,
      BT body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength}) {
    final conditions = <Checker<Response>>[];
    if (statusCode != null) conditions.add(statusCodeIs(statusCode));
    if (body != null) conditions.add(bodyIs(body));
    if (bytes != null) conditions.add(bodyBytesIs(bytes));
    if (mimeType != null) conditions.add(mimeTypeIs(mimeType));
    if (encoding != null) conditions.add(encodingIs(encoding));
    if (headers != null) {
      headers.forEach(
          (String key, String value) => conditions.add(headersHas(key, value)));
    }
    return expect(conditions);
  }

  TResponse<BT> run(ResponseHook<BT> func) {
    func(this);
    return this;
  }

  T map<T>(FutureOr<T> func(Response<BT> resp)) {
    return func(this);
  }

  @override
  String toString() {
    return 'TResponse{statusCode: $statusCode, url: ${request.url}, mimeType: $mimeType, encoding: $encoding, body: $body}';
  }
}

class StringResponse implements Response<String> {
  final int statusCode;

  String _body;

  final List<int> bytes;

  final Map<String, String> headers;

  final bool isRedirect;

  final bool persistentConnection;

  final String reasonPhrase;

  final int contentLength;

  final http.BaseRequest request;

  final RouteBase sender;

  final RouteBase sent;

  final String mimeType;

  final String encoding;

  StringResponse(
      {this.statusCode,
      this.bytes,
      this.headers,
      this.isRedirect,
      this.persistentConnection,
      this.reasonPhrase,
      this.contentLength,
      this.request,
      @required this.sender,
      @required this.sent,
      this.mimeType,
      this.encoding});

  factory StringResponse.from(http.Response resp,
      {@required RouteBase sender, @required RouteBase sent}) {
    final mediaType = MediaType.parse(
        resp.headers['content-type'] ?? Response.defaultContentType);
    return StringResponse(
        statusCode: resp.statusCode,
        bytes: resp.bodyBytes,
        headers: resp.headers,
        isRedirect: resp.isRedirect,
        persistentConnection: resp.persistentConnection,
        reasonPhrase: resp.reasonPhrase,
        contentLength: resp.contentLength,
        request: resp.request,
        sender: sender,
        sent: sent,
        mimeType: mediaType.mimeType,
        encoding: mediaType.parameters['charset'] ?? Response.defaultCharset);
  }

  String get body => _body ??= _getEncoderForCharset(encoding).decode(bytes);

  StringResponse get toStringResponse => this;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  bool get isFailure => statusCode >= 400 && statusCode < 600;

  Future<StringResponse> onSuccess(ResponseHook<String> func) async {
    if (isSuccess) await func(this);
    return this;
  }

  Future<StringResponse> onFailure(ResponseHook<String> func) async {
    if (isFailure) await func(this);
    return this;
  }

  TResponse<T> json<T>([T convert(Map d)]) {
    final d = codec.json.decode(body);
    T ret;
    if (convert != null)
      ret = convert(d);
    else
      ret = d;
    return TResponse<T>(
      statusCode: statusCode,
      body: ret,
      bytes: bytes,
      headers: headers,
      isRedirect: isRedirect,
      persistentConnection: persistentConnection,
      reasonPhrase: reasonPhrase,
      contentLength: contentLength,
      request: request,
      sender: sender,
      sent: sent,
      mimeType: mimeType,
      encoding: encoding,
    );
  }

  TResponse<List<T>> jsonList<T>([T convert(Map d)]) {
    List d = codec.json.decode(body);
    List<T> ret;
    if (convert != null)
      ret = d.cast<Map>().map(convert).cast<T>().toList();
    else
      ret = d.cast<T>();
    return TResponse<List<T>>(
      statusCode: statusCode,
      body: ret,
      bytes: bytes,
      headers: headers,
      isRedirect: isRedirect,
      persistentConnection: persistentConnection,
      reasonPhrase: reasonPhrase,
      contentLength: contentLength,
      request: request,
      sender: sender,
      sent: sent,
      mimeType: mimeType,
      encoding: encoding,
    );
  }

  T decodeJson<T>([T convert(Map d)]) {
    final d = codec.json.decode(body);
    if (convert == null) return d;
    return convert(d);
  }

  List<T> decodeJsonList<T>([T convert(Map d)]) {
    List d = codec.json.decode(body);
    if (convert != null) return d.cast<Map>().map(convert).cast<T>().toList();
    return d.cast<T>();
  }

  StringResponse expect(List<Checker<Response>> conditions) {
    final mismatches = conditions
        .map((c) => c(this))
        .reduce((List<Mismatch> v, List<Mismatch> e) => v..addAll(e))
        .toList();
    if (mismatches.length != 0) throw mismatches;
    return this;
  }

  StringResponse exact(
      {int statusCode,
      String body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength}) {
    final conditions = <Checker<Response>>[];
    if (statusCode != null) conditions.add(statusCodeIs(statusCode));
    if (body != null) conditions.add(bodyIs(body));
    if (bytes != null) conditions.add(bodyBytesIs(bytes));
    if (mimeType != null) conditions.add(mimeTypeIs(mimeType));
    if (encoding != null) conditions.add(encodingIs(encoding));
    if (headers != null) {
      headers.forEach(
          (String key, String value) => conditions.add(headersHas(key, value)));
    }
    return expect(conditions);
  }

  StringResponse run(ResponseHook<String> func) {
    func(this);
    return this;
  }

  T map<T>(FutureOr<T> func(StringResponse resp)) {
    return func(this);
  }

  Map<String, ClientCookie> get cookies =>
      parseSetCookie(headers['set-cookie']);

  @override
  String toString() {
    return 'StringResponse{statusCode: $statusCode, url: ${request.url}, mimeType: $mimeType, encoding: $encoding, body: $body}';
  }
}

codec.Encoding _getEncoderForCharset(String charset,
    [codec.Encoding fallback = codec.latin1]) {
  if (charset == null) return fallback;
  var encoding = codec.Encoding.getByName(charset);
  return encoding == null ? fallback : encoding;
}
