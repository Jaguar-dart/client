part of http.json;

class AsyncJsonResponse extends DelegatingFuture<JsonResponse>
    implements resty.AsyncResponse<String> {
  /// Json serializer repository
  final JsonRepo repo;

  AsyncJsonResponse(this.repo, Future<JsonResponse> inner) : super(inner);

  AsyncJsonResponse.from(this.repo, Future<http.Response> inner)
      : super(inner.then((r) => new JsonResponse.from(repo, r)));

  AsyncJsonResponse.fromAsyncStringResponse(
      this.repo, resty.AsyncStringResponse resp)
      : super(resp.then((resty.StringResponse r) =>
            new JsonResponse.fromStringResponse(repo, r)));

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

  AsyncJsonResponse onSuccess(resty.After<String> func) => run((r) async {
        if (r.isSuccess) await func(r);
      });

  AsyncJsonResponse expect(List<resty.Checker<resty.Response>> conditions) =>
      new AsyncJsonResponse(repo, then((r) => r.expect(conditions)));

  AsyncJsonResponse exact(
      {int statusCode,
      String body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength}) {
    return new AsyncJsonResponse(
        repo,
        then((r) => r.exact(
            statusCode: statusCode,
            body: body,
            bytes: bytes,
            mimeType: mimeType,
            encoding: encoding,
            headers: headers,
            contentLength: contentLength)));
  }

  resty.AsyncTResponse<T> json<T>([T convert(Map d)]) =>
      new resty.AsyncTResponse<T>(
          then((resty.StringResponse r) => r.json<T>(convert)));

  resty.AsyncTResponse<List<T>> jsonList<T>([T convert(Map d)]) =>
      new resty.AsyncTResponse<List<T>>(
          then((resty.StringResponse r) => r.jsonList<T>(convert)));

  Future<T> decode<T>([T convert(Map d)]) => then((r) => r.decode<T>(convert));

  Future<List<T>> decodeList<T>([T convert(Map d)]) =>
      then((resty.StringResponse r) => r.decodeList<T>(convert));

  /// Runs [func] with [Response] object after request completion
  AsyncJsonResponse run(resty.After<String> func) =>
      new AsyncJsonResponse(repo, then((r) async {
        await func(r);
        return r;
      }));

  /// Runs [funcs] with [Response] object after request completion
  AsyncJsonResponse runAll(List<resty.After<String>> funcs) =>
      new AsyncJsonResponse(repo, then((r) async {
        for (resty.After<String> func in funcs) await func(r);
        return r;
      }));

  Future<T> withSerializer<T>(Serializer<T> serializer) =>
      then((r) => r.withSerializer<T>(serializer));

  Future<List<T>> listWithSerializer<T>(Serializer<T> serializer) =>
      then((r) => r.listWithSerializer<T>(serializer));

  Future<T> withRepo<T>(JsonRepo repo) => then((r) => r.withRepo<T>(repo));

  Future<List<T>> listWithRepo<T>(JsonRepo repo) =>
      then((r) => r.listWithRepo<T>(repo));
}

/// Response of the JSON request
class JsonResponse extends resty.StringResponse {
  /// Json serializer repository
  final JsonRepo repo;

  JsonResponse(this.repo,
      {int statusCode,
      String body,
      List<int> bytes,
      Map<String, String> headers,
      bool isRedirect,
      bool persistentConnection,
      String reasonPhrase,
      int contentLength,
      http.BaseRequest request,
      String mimeType,
      String encoding})
      : super(
            statusCode: statusCode,
            body: body,
            bytes: bytes,
            headers: headers,
            isRedirect: isRedirect,
            persistentConnection: persistentConnection,
            reasonPhrase: reasonPhrase,
            contentLength: contentLength,
            request: request,
            mimeType: mimeType,
            encoding: encoding);

  JsonResponse.fromStringResponse(this.repo, resty.StringResponse resp)
      : super(
            statusCode: resp.statusCode,
            body: resp.body,
            bytes: resp.bytes,
            headers: resp.headers,
            isRedirect: resp.isRedirect,
            persistentConnection: resp.persistentConnection,
            reasonPhrase: resp.reasonPhrase,
            contentLength: resp.contentLength,
            request: resp.request,
            mimeType: resp.mimeType,
            encoding: resp.encoding);

  factory JsonResponse.from(JsonRepo repo, http.Response resp) =>
      new JsonResponse(repo,
          statusCode: resp.statusCode,
          body: resp.body,
          bytes: resp.bodyBytes,
          headers: resp.headers,
          isRedirect: resp.isRedirect,
          persistentConnection: resp.persistentConnection,
          reasonPhrase: resp.reasonPhrase,
          contentLength: resp.contentLength,
          request: resp.request,
          mimeType: resty.Response.parseMimeType(resp.headers['content-type']),
          encoding: resty.Response.parseEncoding(resp.headers['content-type']));

  JsonResponse onSuccess(resty.After<String> func) => super.onSuccess(func);

  T decode<T>([T convert(Map<String, dynamic> d)]) {
    if (convert != null) return super.decode<T>(convert);
    if (repo != null) return repo.decodeOne<T>(body);
    return super.decode<T>();
  }

  List<T> decodeList<T>([T convert(Map<String, dynamic> d)]) {
    if (convert != null) return super.decodeList<T>(convert);
    if (repo != null) return repo.decodeList<T>(body);
    return super.decodeList<T>();
  }

  T withSerializer<T>(Serializer<T> serializer) =>
      decode<T>(serializer.fromMap);

  List<T> listWithSerializer<T>(Serializer<T> serializer) =>
      decodeList<T>(serializer.fromMap);

  T withRepo<T>(JsonRepo repo) => repo.decodeOne<T>(body);

  List<T> listWithRepo<T>(JsonRepo repo) => repo.decodeList<T>(body);

  JsonResponse expect(List<resty.Checker<resty.Response>> conditions) =>
      super.expect(conditions);

  JsonResponse exact(
          {int statusCode,
          String body,
          List<int> bytes,
          String mimeType,
          String encoding,
          Map<String, String> headers,
          int contentLength}) =>
      super.exact(
          statusCode: statusCode,
          body: body,
          bytes: bytes,
          mimeType: mimeType,
          encoding: encoding,
          headers: headers,
          contentLength: contentLength);

  JsonResponse run(resty.After<String> func) => super.run(func);

  /// Runs [funcs] with [Response] object after request completion
  JsonResponse runAll(List<resty.After<String>> funcs) => super.runAll(funcs);
}
