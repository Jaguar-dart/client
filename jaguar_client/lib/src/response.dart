part of http.json;

class AsyncJsonResponse extends resty.AsyncStringResponse
    implements resty.AsyncResponse<String> {
  /// Json serializer repository
  final JsonRepo repo;

  AsyncJsonResponse(this.repo, Future<JsonResponse> inner) : super(inner);

  AsyncJsonResponse.fromAsyncStringResponse(
      this.repo, resty.AsyncStringResponse resp)
      : super(resp.then((resty.StringResponse r) =>
            JsonResponse.fromStringResponse(repo, r)));

  @override
  Future<S> then<S>(FutureOr<S> onValue(JsonResponse value),
          {Function onError}) =>
      super.then(onValue, onError: onError);

  @override
  AsyncJsonResponse onFailure(resty.ResponseHook<String> hook) =>
      AsyncJsonResponse.fromAsyncStringResponse(repo, super.onFailure(hook));

  @override
  AsyncJsonResponse onSuccess(resty.ResponseHook<String> hook) =>
      AsyncJsonResponse.fromAsyncStringResponse(repo, super.onSuccess(hook));

  AsyncJsonResponse expect(List<resty.Checker<resty.Response>> conditions) =>
      AsyncJsonResponse(repo, then((r) => r.expect(conditions)));

  AsyncJsonResponse exact(
      {int statusCode,
      String body,
      List<int> bytes,
      String mimeType,
      String encoding,
      Map<String, String> headers,
      int contentLength}) {
    return AsyncJsonResponse(
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
      resty.AsyncTResponse<T>(
          then((resty.StringResponse r) => r.json<T>(convert)));

  resty.AsyncTResponse<List<T>> jsonList<T>([T convert(Map d)]) =>
      resty.AsyncTResponse<List<T>>(
          then((resty.StringResponse r) => r.jsonList<T>(convert)));

  Future<T> decode<T>([T convert(Map d)]) => then((r) => r.decode<T>(convert));

  Future<List<T>> decodeList<T>([T convert(Map d)]) =>
      then((resty.StringResponse r) => r.decodeList<T>(convert));

  @override
  AsyncJsonResponse run(resty.ResponseHook<String> func) =>
      AsyncJsonResponse.fromAsyncStringResponse(repo, super.run(func));

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
      @required resty.RouteBase sender,
      @required resty.RouteBase sent,
      String mimeType,
      String encoding})
      : super(
            statusCode: statusCode,
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
            encoding: encoding);

  JsonResponse.fromStringResponse(this.repo, resty.StringResponse resp)
      : super(
            statusCode: resp.statusCode,
            bytes: resp.bytes,
            headers: resp.headers,
            isRedirect: resp.isRedirect,
            persistentConnection: resp.persistentConnection,
            reasonPhrase: resp.reasonPhrase,
            contentLength: resp.contentLength,
            request: resp.request,
            sender: resp.sender,
            sent: resp.sent,
            mimeType: resp.mimeType,
            encoding: resp.encoding);

  // JsonResponse onSuccess(resty.After<String> func) => super.onSuccess(func);

  resty.StringResponse get toStringResponse => this;

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

  /*
  JsonResponse run(resty.After<String> func) => super.run(func);

  /// Runs [funcs] with [Response] object after request completion
  JsonResponse runAll(List<resty.After<String>> funcs) => super.runAll(funcs);
  */
}
