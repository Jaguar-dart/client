part of http.json;

class JsonClient {
  /// The underlying http client used to make the requests
  final http.Client client;

  final JsonRepo repo;

  final String basePath;

  final bool manageCookie;

  final Map<String, String> defaultHeaders = {};

  String bearerAuthHeader;

  final resty.CookieJar jar = new resty.CookieJar();

  JsonClient(this.client, {this.repo, this.manageCookie: false, this.basePath});

  Uri _makeUri(/* String | Uri */ url) {
    if (url is String) {
      if (basePath is String) url = basePath + url;
      return Uri.parse(url);
    } else {
      return url;
    }
  }

  resty.Route _makeRoute(/* String | Uri */ url) {
    Uri uri = _makeUri(url);

    final route = resty.Route(uri.path).withClient(client);
    if (uri.hasAuthority) route.origin(uri.origin);
    route.queries(uri.queryParametersAll);

    return route;
  }

  /// Issues a JSON GET request and returns decoded JSON response as [JsonResponse]
  AsyncJsonResponse get(/* String | Uri */ url,
      {final Map<String, String> headers,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final item = _makeRoute(url).get;

    if (headers != null) item.headers(headers);
    _addHeaders(item);

    before.forEach(item.interceptBefore);
    after.forEach(item.interceptAfter);

    return new AsyncJsonResponse.fromAsyncStringResponse(repo, item.go());
  }

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  AsyncJsonResponse post(url,
      {final Map<String, String> headers,
      body,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final item = _makeRoute(url).post;

    if (headers != null) item.headers(headers);
    _addHeaders(item);

    if (body != null) {
      if (repo != null)
        item.json(repo.to(body));
      else
        item.json(body);
    }

    before.forEach(item.interceptBefore);
    after.forEach(item.interceptAfter);

    return new AsyncJsonResponse.fromAsyncStringResponse(repo, item.go());
  }

  /// Issues a JSON PUT request and returns decoded JSON response as
  /// [JsonResponse]
  AsyncJsonResponse put(url,
      {final Map<String, String> headers,
      body,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final item = _makeRoute(url).put;

    if (headers != null) item.headers(headers);
    _addHeaders(item);

    if (body != null) {
      if (repo != null)
        item.json(repo.to(body));
      else
        item.json(body);
    }

    before.forEach(item.interceptBefore);
    after.forEach(item.interceptAfter);

    return new AsyncJsonResponse.fromAsyncStringResponse(repo, item.go());
  }

  /// Issues a JSON DELETE request and returns decoded JSON response as
  /// [JsonResponse]
  AsyncJsonResponse delete(url,
      {final Map<String, String> headers,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final item = _makeRoute(url).delete;

    if (headers != null) item.headers(headers);
    _addHeaders(item);

    before.forEach(item.interceptBefore);
    after.forEach(item.interceptAfter);

    return new AsyncJsonResponse.fromAsyncStringResponse(repo, item.go());
  }

  AsyncJsonResponse postForm(url,
      {final Map<String, String> headers,
      body,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final item = _makeRoute(url).post;

    if (headers != null) item.headers(headers);
    _addHeaders(item);

    if (body != null) {
      if (repo != null)
        item.urlEncodedForm(repo.to(body));
      else
        item.urlEncodedForm(body);
    }

    before.forEach(item.interceptBefore);
    after.forEach(item.interceptAfter);

    return new AsyncJsonResponse.fromAsyncStringResponse(repo, item.go());
  }

  /// Issues a JSON PUT request with url-encoded-form body and returns decoded
  /// JSON response as [JsonResponse]
  ///
  /// [url] can be [String] or [Uri]
  /// [headers] parameters can be used to add HTTP headers
  /// [body] can be a Dart built-in type or any PODO object. If it is PODO, [repo]
  /// is used to serialize the object
  AsyncJsonResponse putForm(url,
      {final Map<String, String> headers,
      body,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final item = _makeRoute(url).put;

    if (headers != null) item.headers(headers);
    _addHeaders(item);

    if (body != null) {
      if (repo != null)
        item.urlEncodedForm(repo.to(body));
      else
        item.urlEncodedForm(body);
    }

    before.forEach(item.interceptBefore);
    after.forEach(item.interceptAfter);

    return new AsyncJsonResponse.fromAsyncStringResponse(repo, item.go());
  }

  static const String recapHeader = 'jaguar-recaptcha';

  /// Authenticates using JSON body
  ///
  /// \param[in] username Username for authentication
  /// \param[in] password Password for authentication
  /// \param[in] payload Extra payload
  AsyncJsonResponse authenticate(AuthPayload payload,
      {url: '/api/login',
      final Map<String, String> headers,
      bool captureAuthToken: false,
      String reCaptchaResp,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final item = _makeRoute(url).post;

    final reqHeaders = new Map<String, String>.from(headers ?? {});
    if (reCaptchaResp is String) reqHeaders[recapHeader] = reCaptchaResp;
    item.headers(reqHeaders);

    _addHeaders(item);

    item.json(payload.toMap());

    before.forEach(item.interceptBefore);
    after.forEach(item.interceptAfter);

    if (captureAuthToken) item.interceptAfter(_captureBearerHeader);

    return new AsyncJsonResponse.fromAsyncStringResponse(repo, item.go());
  }

  /// Authenticates using url-encoded-form
  ///
  /// \param[in] payload Authentication payload
  AsyncJsonResponse authenticateForm(AuthPayload payload,
      {url: '/api/login',
      final Map<String, String> headers,
      bool captureAuthToken: false,
      String reCaptchaResp,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final item = _makeRoute(url).post;

    final reqHeaders = new Map<String, String>.from(headers ?? {});
    if (reCaptchaResp is String) reqHeaders[recapHeader] = reCaptchaResp;
    if (headers != null) item.headers(reqHeaders);

    _addHeaders(item);

    item.urlEncodedForm(payload.toMap());

    before.forEach(item.interceptBefore);
    after.forEach(item.interceptAfter);

    if (captureAuthToken) item.interceptAfter(_captureBearerHeader);

    return new AsyncJsonResponse.fromAsyncStringResponse(repo, item.go());
  }

  /// Authenticates using Basic Authentication
  ///
  /// \param[in] payload Authentication payload
  AsyncJsonResponse authenticateBasic(AuthPayload payload,
      {url: '/api/login',
      final Map<String, String> headers,
      bool captureAuthToken: false,
      String reCaptchaResp,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final item = _makeRoute(url).post;

    if (headers != null) item.headers(headers);
    if (reCaptchaResp is String) item.header('recapHeader', reCaptchaResp);

    _addHeaders(item);

    if (payload.extras != null) item.json(payload.extras);

    before.forEach(item.interceptBefore);
    after.forEach(item.interceptAfter);

    item.setBasicAuth(payload.username, payload.password);

    if (captureAuthToken) item.interceptAfter(_captureBearerHeader);

    return new AsyncJsonResponse.fromAsyncStringResponse(repo, item.go());
  }

  AsyncJsonResponse logout(
      {url: '/api/logout',
      body,
      final Map<String, String> headers,
      bool removeAuthToken: false,
      List<resty.Before> before: const [],
      List<resty.After> after: const []}) {
    final AsyncJsonResponse ret =
        post(url, body: body, headers: headers, before: before, after: after);
    if (removeAuthToken) ret.onSuccess((_) => bearerAuthHeader = null);
    return ret;
  }

  void _captureBearerHeader(resty.Response resp) {
    final authHeader =
        new AuthHeaders.fromHeaderStr(resp.headers['authorization']);
    bearerAuthHeader = authHeader.items['Bearer']?.credentials;
  }

  void _addHeaders(resty.RouteBase route) {
    route.header("X-Requested-With", "XMLHttpRequest");
    route.headers(defaultHeaders);
    route.header('Accept', 'application/json');

    if (manageCookie) route.interceptBefore(jar.intercept);

    if (bearerAuthHeader is String) route.setAuthToken(bearerAuthHeader);
  }

  /* TODO
  ResourceClient<IdType, ModelType>
      resource<IdType, ModelType extends Idied<IdType>>(
          Serializer<ModelType> serializer,
          {String basePath,
          StringToId<IdType> stringToId}) {
    return new ResourceClient(client, serializer,
        basePath: basePath, stringToId: stringToId);
  }

  ResourceClient<IdType, ModelType>
      resourceFromRepo<IdType, ModelType extends Idied<IdType>>(
          {String basePath, StringToId<IdType> stringToId}) {
    return new ResourceClient(client, repo.getByType(ModelType),
        basePath: basePath, stringToId: stringToId);
  }

  SerializedJsonClient serialized() => new SerializedJsonClient(this);
  */
}
