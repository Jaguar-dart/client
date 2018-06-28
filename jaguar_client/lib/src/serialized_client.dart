part of http.json;

/* TODO
/// Json client with a base path
class SerializedJsonClient {
  /// The underlying http client used to make the requests
  final JsonClient jClient;

  JsonRepo get repo => jClient.repo;

  http.Client get client => jClient.client;

  SerializedJsonClient(this.jClient);

  /// Issues a JSON GET request and returns decoded JSON response as [JsonResponse]
  Future<dynamic> get(String url,
      {Map<String, String> headers, Type type}) async {
    final JsonResponse resp = await jClient.get(url, headers: headers);
    return resp.deserialize(type: type);
  }

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<dynamic> post(String url,
      {Map<String, String> headers, dynamic body, Type type}) async {
    final JsonResponse resp =
        await jClient.post(url, headers: headers, body: body);
    return resp.deserialize(type: type);
  }

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<dynamic> put(url,
      {Map<String, String> headers, dynamic body, Type type}) async {
    final JsonResponse resp =
        await jClient.put(url, headers: headers, body: body);
    return resp.deserialize(type: type);
  }

  /// Issues a JSON DELETE request and returns decoded JSON response as [JsonResponse]
  Future<dynamic> delete(url,
      {Map<String, String> headers, body, Type type}) async {
    final JsonResponse resp = await jClient.delete(url, headers: headers);
    return resp.deserialize(type: type);
  }

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<dynamic> postForm(String url,
      {Map<String, String> headers, dynamic body, Type type}) async {
    final JsonResponse resp =
        await jClient.postForm(url, headers: headers, body: body);
    return resp.deserialize(type: type);
  }

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<dynamic> putForm(url,
      {Map<String, String> headers, dynamic body, Type type}) async {
    final JsonResponse resp =
        await jClient.putForm(url, headers: headers, body: body);
    return resp.deserialize(type: type);
  }

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
}
*/