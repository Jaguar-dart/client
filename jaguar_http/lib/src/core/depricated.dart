
/*
class JaguarRequest<T> {
  T body;
  String method;
  String url;
  Map<String, String> headers;

  JaguarRequest({this.method, this.headers, this.body, this.url});

  Future<http.Response> send(http.Client client) async {
    switch (method) {
      case "POST":
        return client.post(url, headers: headers, body: body);
      case "PUT":
        return client.put(url, headers: headers, body: body);
      case "PATCH":
        return client.patch(url, headers: headers, body: body);
      case "DELETE":
        return client.delete(url, headers: headers);
      default:
        return client.get(url, headers: headers);
    }
  }
}

abstract class JaguarApiDefinition {
  final String baseUrl;
  final Map headers;
  final http.Client client;
  final SerializerRepo serializers;

  JaguarApiDefinition(
      this.client, this.baseUrl, Map headers, SerializerRepo serializers)
      : headers = headers ?? {'content-type': 'application/json'},
        serializers = serializers ?? new JsonRepo();

  final List<RequestInterceptor> requestInterceptors = [];
  final List<ResponseInterceptor> responseInterceptors = [];

  @protected
  FutureOr<JaguarRequest> interceptRequest(JaguarRequest request) async {
    for (var requestInterceptor in requestInterceptors) {
      request = await requestInterceptor(request);
    }
    return request;
  }

  @protected
  FutureOr<JaguarResponse> interceptResponse(JaguarResponse response) async {
    for (var responseInterceptor in responseInterceptors) {
      response = await responseInterceptor(response);
    }
    return response;
  }
}

class JaguarResponse<T> {
  final T body;
  final http.Response rawResponse;

  JaguarResponse(this.body, this.rawResponse);

  JaguarResponse.error(this.rawResponse) : body = null;

  bool isSuccessful() =>
      rawResponse.statusCode >= 200 && rawResponse.statusCode < 300;

  String toString() => "JaguarResponse($body)";
}
*/
