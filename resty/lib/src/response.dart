import 'dart:async';
import 'package:http/http.dart' as http;
import 'expect.dart';
import 'package:async/async.dart';
import 'dart:convert' as codec;

typedef dynamic After<T>(Response<T> response);

abstract class AsyncResponse<BT> {
  FutureOr<int> get statusCode;

  FutureOr<bool> get isSuccess;

  FutureOr<BT> get body;

  FutureOr<List<int>> get bytes;

  FutureOr<Map<String, String>> get headers;

  FutureOr<bool> get isRedirect;

  FutureOr<bool> get persistentConnection;

  FutureOr<String> get reasonPhrase;

  FutureOr<int> get contentLength;

  FutureOr<http.BaseRequest> get request;

  FutureOr<String> get mimeType;

  FutureOr<String> get encoding;

  AsyncResponse<BT> onSuccess(After<BT> func);

  AsyncResponse<BT> expect(List<Checker<Response>> conditions);

  AsyncResponse<BT> exact(
      {int statusCode,
      BT body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength});

  /// Runs [func] with [Response] object after request completion
  AsyncResponse<BT> run(dynamic func(Response<BT> resp));

  /// Runs [funcs] with [Response] object after request completion
  AsyncResponse<BT> runAll(List<After<BT>> funcs);
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

  Future<String> get mimeType => then((r) => r.mimeType);

  Future<String> get encoding => then((r) => r.encoding);

  Future<bool> get isSuccess => then((r) => r.isSuccess);

  AsyncTResponse<BT> onSuccess(After<BT> func) => run((r) async {
        if (r.isSuccess) await func(r);
      });

  AsyncTResponse<BT> expect(List<Checker<Response>> conditions) {
    return new AsyncTResponse<BT>(then((r) => r.expect(conditions)));
  }

  AsyncTResponse<BT> exact(
      {int statusCode,
      BT body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength}) {
    return new AsyncTResponse<BT>(then((r) {
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
  AsyncTResponse<BT> run(After<BT> func) =>
      new AsyncTResponse<BT>(then((r) async {
        await func(r);
        return r;
      }));

  /// Runs [funcs] with [Response] object after request completion
  AsyncTResponse<BT> runAll(List<After<BT>> funcs) =>
      new AsyncTResponse<BT>(then((r) async {
        for (After<BT> func in funcs) await func(r);
        return r;
      }));
}

class AsyncStringResponse extends DelegatingFuture<StringResponse>
    implements AsyncResponse<String> {
  AsyncStringResponse(Future<StringResponse> inner) : super(inner);

  AsyncStringResponse.from(Future<http.Response> inner)
      : super(inner.then((r) => new StringResponse.from(r)));

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

  AsyncStringResponse onSuccess(After<String> func) => run((r) async {
        if (r.isSuccess) await func(r);
      });

  AsyncStringResponse expect(List<Checker<Response>> conditions) {
    return new AsyncStringResponse(then((r) => r.expect(conditions)));
  }

  AsyncStringResponse exact(
      {int statusCode,
      String body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength}) {
    return new AsyncStringResponse(then((r) => r.exact(
        statusCode: statusCode,
        body: body,
        bytes: bytes,
        mimeType: mimeType,
        encoding: encoding,
        headers: headers,
        contentLength: contentLength)));
  }

  AsyncTResponse<T> json<T>([T convert(Map d)]) =>
      new AsyncTResponse<T>(then((StringResponse r) => r.json<T>(convert)));

  AsyncTResponse<List<T>> jsonList<T>([T convert(Map d)]) =>
      new AsyncTResponse<List<T>>(
          then((StringResponse r) => r.jsonList<T>(convert)));

  Future<T> decode<T>([T convert(Map d)]) => then((r) => r.decode<T>(convert));

  Future<List<T>> decodeList<T>([T convert(Map d)]) =>
      then((StringResponse r) => r.decodeList<T>(convert));

  /// Runs [func] with [Response] object after request completion
  AsyncStringResponse run(After<String> func) =>
      new AsyncStringResponse(then((r) async {
        await func(r);
        return r;
      }));

  /// Runs [funcs] with [Response] object after request completion
  AsyncStringResponse runAll(List<After<String>> funcs) =>
      new AsyncStringResponse(then((r) async {
        for (After<String> func in funcs) await func(r);
        return r;
      }));
}

abstract class Response<T> implements AsyncResponse<T> {
  int get statusCode;

  bool get isSuccess;

  T get body;

  List<int> get bytes;

  Map<String, String> get headers;

  bool get isRedirect;

  bool get persistentConnection;

  String get reasonPhrase;

  int get contentLength;

  http.BaseRequest get request;

  String get mimeType;

  String get encoding;

  Response<T> expect(List<Checker<Response>> conditions);

  Response<T> exact(
      {int statusCode,
      T body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength});

  Response<T> run(After<T> func);

  /// Runs [funcs] with [Response] object after request completion
  Response<T> runAll(List<After<T>> funcs);

  static String parseMimeType(String header) {
    header ??= '';
    List<String> parts = header.split(';');
    if (parts.length == 0) return 'text/plain';
    return parts.first.trim();
  }

  static String parseEncoding(String header) {
    header ??= '';
    List<String> parts = header.split(';');
    if (parts.length < 2) return 'utf-8';
    parts.removeAt(0);
    return parts.map((s) {
      List<String> parts = s.split('=');
      if (parts.length != 2) return null;
      if (parts.first != 'charset') return null;
      return parts[1];
    }).firstWhere((e) => e != null, orElse: () => 'utf-8');
  }
}

class TResponse<T> implements Response<T> {
  final int statusCode;

  final T body;

  final List<int> bytes;

  final Map<String, String> headers;

  final bool isRedirect;

  final bool persistentConnection;

  final String reasonPhrase;

  final int contentLength;

  final http.BaseRequest request;

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
      this.mimeType,
      this.encoding});

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  TResponse<T> onSuccess(After<T> func) => run((r) async {
        if (r.isSuccess) await func(r);
      });

  TResponse<T> expect(List<Checker<Response>> conditions) {
    final mismatches = conditions
        .map((c) => c(this))
        .reduce((List<Mismatch> v, List<Mismatch> e) => v..addAll(e))
        .toList();
    if (mismatches.length != 0) throw mismatches;
    return this;
  }

  TResponse<T> exact(
      {int statusCode,
      T body,
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

  TResponse<T> run(After<T> func) {
    func(this);
    return this;
  }

  /// Runs [funcs] with [Response] object after request completion
  TResponse<T> runAll(List<After<T>> funcs) {
    for (After<T> func in funcs) func(this);
    return this;
  }
}

class StringResponse implements Response<String> {
  final int statusCode;

  final String body;

  final List<int> bytes;

  final Map<String, String> headers;

  final bool isRedirect;

  final bool persistentConnection;

  final String reasonPhrase;

  final int contentLength;

  final http.BaseRequest request;

  final String mimeType;

  final String encoding;

  StringResponse(
      {this.statusCode,
      this.body,
      this.bytes,
      this.headers,
      this.isRedirect,
      this.persistentConnection,
      this.reasonPhrase,
      this.contentLength,
      this.request,
      this.mimeType,
      this.encoding});

  factory StringResponse.from(http.Response resp) => new StringResponse(
      statusCode: resp.statusCode,
      body: resp.body,
      bytes: resp.bodyBytes,
      headers: resp.headers,
      isRedirect: resp.isRedirect,
      persistentConnection: resp.persistentConnection,
      reasonPhrase: resp.reasonPhrase,
      contentLength: resp.contentLength,
      request: resp.request,
      mimeType: Response.parseMimeType(resp.headers['content-type']),
      encoding: Response.parseEncoding(resp.headers['content-type']));

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  StringResponse onSuccess(After<String> func) => run((r) async {
        if (r.isSuccess) await func(r);
      });

  TResponse<T> json<T>([T convert(Map d)]) {
    final d = codec.json.decode(body);
    T ret;
    if (convert != null)
      ret = convert(d);
    else
      ret = d;
    return new TResponse<T>(
      statusCode: statusCode,
      body: ret,
      bytes: bytes,
      headers: headers,
      isRedirect: isRedirect,
      persistentConnection: persistentConnection,
      reasonPhrase: reasonPhrase,
      contentLength: contentLength,
      request: request,
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
    return new TResponse<List<T>>(
      statusCode: statusCode,
      body: ret,
      bytes: bytes,
      headers: headers,
      isRedirect: isRedirect,
      persistentConnection: persistentConnection,
      reasonPhrase: reasonPhrase,
      contentLength: contentLength,
      request: request,
      mimeType: mimeType,
      encoding: encoding,
    );
  }

  T decode<T>([T convert(Map d)]) {
    final d = codec.json.decode(body);
    if (convert == null) return d;
    return convert(d);
  }

  List<T> decodeList<T>([T convert(Map d)]) {
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

  StringResponse run(After<String> func) {
    func(this);
    return this;
  }

  /// Runs [funcs] with [Response] object after request completion
  StringResponse runAll(List<After<String>> funcs) {
    for (After<String> func in funcs) func(this);
    return this;
  }
}
